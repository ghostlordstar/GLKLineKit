//
//  LandscapeController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "LandscapeController.h"
#import "FullScreenKLineView.h"
#import "KLineDataProcess.h"
#import "UIColor+Hex.h"
#import "ListMenuView.h"

#define kBaseBtnTag (7893)

@interface LandscapeController ()<ListMenuViewProtocol,UIGestureRecognizerDelegate>
/**
 横屏行情视图
 */
@property (strong, nonatomic) FullScreenKLineView *fullKLineView;

/**
 底图
 */
@property (strong, nonatomic) UIView *backView;

/**
 symbolLabel
 */
@property (strong, nonatomic) UILabel *symbolLabel;

/**
 currentPrice
 */
@property (strong, nonatomic) UILabel *currentPriceLabel;

/**
 24h涨跌
 */
@property (strong, nonatomic) UILabel *hour_24_changeLabel;

/**
 关闭按钮
 */
@property (strong, nonatomic) UIButton *quitBtn;

/**
 右侧的指标选择菜单
 */
@property (strong, nonatomic) ListMenuView * indicatorSelectView;

/**
 下方的时间选择视图
 */
@property (strong, nonatomic) ListMenuView * timeSelectView;

/**
 分钟选择按钮
 */
@property (strong, nonatomic) UIButton *minuteBtn;

/**
 小时选择按钮
 */
@property (strong, nonatomic) UIButton *hourBtn;

/**
 分时按钮
 */
@property (strong, nonatomic) UIButton *timeLineBtn;

/**
 日线按钮
 */
@property (strong, nonatomic) UIButton *dayLineBtn;

/**
 周线按钮
 */
@property (strong, nonatomic) UIButton *weekLineBtn;

/**
 背景视图手势
 */
@property (strong, nonatomic) UITapGestureRecognizer *backTapGesture;

/**
 bottom btn 集合
 */
@property (strong, nonatomic) NSArray *bottomBtnArray;

@end

@implementation LandscapeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self p_initialize];
    // 添加视图
    [self p_setUpUI];
    // 旋转底图
    [self p_transFormBackView];
    // 加载数据
    [self p_getDataToKline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - 控件事件 ---

- (void)p_backViewTapAction:(UITapGestureRecognizer *)tap {
    
    [self p_hideSelectedView];
}

/**
 退出按钮事件
 
 @param btn 退出按钮
 */
- (void)p_quitBtnAction:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 下方切换K线周期的按钮事件
 
 @param btn 切换按钮
 */
- (void)p_timeBtnAction:(UIButton *)btn {
    
    NSUInteger tag = btn.tag - kBaseBtnTag;
    
    switch (tag) {
        case 0:
        {   // 分时
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLineWithMA];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] cleanOtherItemCurrentSection:YES];
            
            [self p_hideSelectedView];
            
            [self p_setSelectedStateForBtn:self.timeLineBtn];
        }
            break;
            
        case 1:
        {   // 日线
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithMA];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] cleanOtherItemCurrentSection:YES];
            
            [self p_hideSelectedView];
                        [self p_setSelectedStateForBtn:self.dayLineBtn];
        }
            break;
            
        case 2:
        {   // 周线
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithMA];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] cleanOtherItemCurrentSection:YES];
            
            [self p_hideSelectedView];
                        [self p_setSelectedStateForBtn:self.weekLineBtn];
        }
            break;
            
        case 3:
        {   // 小时
            if(_timeSelectView && [self.backView.subviews containsObject:_timeSelectView] && _timeSelectView.tag == self.hourBtn.tag) {
                [self p_hideSelectedView];
            }else {
                
                [self p_showSelectedViewWithBtn:self.hourBtn];
            }
        }
            break;
            
        case 4:
        {   // 分钟
            if(_timeSelectView && [self.backView.subviews containsObject:_timeSelectView] && _timeSelectView.tag == self.minuteBtn.tag) {
                [self p_hideSelectedView];
            }else {
                
                [self p_showSelectedViewWithBtn:self.minuteBtn];
            }
        }
            
        default:
            break;
    }
}

#pragma mark - ListMenuView protocol ---

- (void)listMenuView:(ListMenuView *)view didSelectedAtIndexPath:(NSIndexPath *)indexPath itemTitle:(NSString *)title {
    
    [self p_hideSelectedView];
    
    if (view.identifier) {
        
        if ([view.identifier isEqualToString:self.indicatorSelectView.identifier]) {
            // 根据标题切换指标
            [self p_switchIndicatorWithSelectedTitle:title indexPath:indexPath];
            
        }else if(view.tag == self.hourBtn.tag){
            [self.minuteBtn setTitle:@"分钟 ▼" forState:UIControlStateNormal];
            [self.hourBtn setTitle:[NSString stringWithFormat:@"%@ ▼",title] forState:UIControlStateNormal];
            [self p_setSelectedStateForBtn:self.hourBtn];
            
            // TODO: 切换分钟k线
            
        }else if(view.tag == self.minuteBtn.tag) {
            [self.hourBtn setTitle:@"小时 ▼" forState:UIControlStateNormal];
            [self.minuteBtn setTitle:[NSString stringWithFormat:@"%@ ▼",title] forState:UIControlStateNormal];
            [self p_setSelectedStateForBtn:self.minuteBtn];
            
            // TODO: 切换小时K线
            
        }
    }
}

- (NSArray *)itemTitlesAtListMenuView:(ListMenuView *)view {
    
    NSArray *dataSource = @[];
    
    if (view.identifier) {
        
        if ([view.identifier isEqualToString:self.indicatorSelectView.identifier]) {
            // 指标
            dataSource = @[@[@"MA",@"BOLL"],@[@"KDJ",@"MACD",@"RSI"]];
        }else if([view.identifier isEqualToString:self.hourBtn.currentTitle]) {
            // 小时
            dataSource = @[@"1小时",@"2小时",@"4小时",@"6小时",@"12小时"];
        }else if([view.identifier isEqualToString:self.minuteBtn.currentTitle]) {
            // 分钟
            dataSource = @[@"1分",@"5分",@"15分",@"30分"];
        }
    }
    return dataSource;
}

#pragma mark - 手势代理方法 ---

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isDescendantOfView:self.timeSelectView] || [touch.view isDescendantOfView:self.indicatorSelectView]){
        return NO;
    }
    return YES;
}

#pragma mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"横屏样式";
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)p_setUpUI {
    
    [self.backView addSubview:self.fullKLineView];
    [self.backView addSubview:self.quitBtn];
    [self.backView addSubview:self.symbolLabel];
    [self.backView addSubview:self.currentPriceLabel];
    [self.backView addSubview:self.hour_24_changeLabel];
    
    [self.backView addSubview:self.indicatorSelectView];
    [self.backView addSubview:self.timeLineBtn];
    [self.backView addSubview:self.dayLineBtn];
    [self.backView addSubview:self.weekLineBtn];
    [self.backView addSubview:self.hourBtn];
    [self.backView addSubview:self.minuteBtn];
    
    [self.view addSubview:self.backView];
    
    [self p_layoutWithMasonry];
}

/**
 使用masonry 布局
 */
- (void)p_layoutWithMasonry {
    
    [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right);
        make.top.equalTo(self.backView.mas_top);
        make.size.mas_equalTo(CGSizeMake(50.0f, 50.0f));
    }];
    
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10.0f);
        make.top.equalTo(self.backView.mas_top);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.symbolLabel.mas_right).offset(20.0f);
        make.top.equalTo(self.symbolLabel);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.hour_24_changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPriceLabel.mas_right).offset(50.0f);
        make.top.equalTo(self.currentPriceLabel);
        make.height.mas_equalTo(50.0f);
    }];
    
    [self.indicatorSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fullKLineView.mas_right);
        make.top.equalTo(self.quitBtn.mas_bottom);
        make.right.equalTo(self.backView.mas_right);
        make.bottom.equalTo(self.fullKLineView.mas_bottom);
    }];
    
    [self.timeLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.backView.frame.size.width / 5.0);
    }];
    
    [self.dayLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLineBtn.mas_right);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.backView.frame.size.width / 5.0);
    }];
    
    [self.weekLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLineBtn.mas_right);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.backView.frame.size.width / 5.0);
    }];
    
    [self.hourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLineBtn.mas_right);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.backView.frame.size.width / 5.0);
    }];
    
    [self.minuteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourBtn.mas_right);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.backView.frame.size.width / 5.0);
    }];
    
}

/**
 对视图进行旋转
 */
- (void)p_transFormBackView {
    
    CGFloat centerX = self.backView.bounds.size.width / 2.0;
    CGFloat centerY = self.backView.bounds.size.height / 2.0;
    
    CGAffineTransform trans = GetCGAffineTransformRotateAroundPoint(centerX, centerY, SCREEN_WIDTH / 2.0, SCREEN_WIDTH / 2.0, M_PI_2);
    
    [self.backView setTransform:trans];
}

/**
 获得旋转的矩阵变换对象
 
 @param centerX 需要旋转的view的Center.x
 @param centerY 需要旋转的view的Center.y
 @param x 旋转中心的x值
 @param y 旋转中心的y值
 @param angle 旋转的角度
 @return 计算后的矩阵变换对象
 */
CGAffineTransform  GetCGAffineTransformRotateAroundPoint(float centerX, float centerY ,float x ,float y ,float angle)
{
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

/**
 加载数据
 */
- (void)p_getDataToKline {
    
    [self.fullKLineView gl_startAnimating];
    
    __weak typeof(self)weakSelf = self;
    // 此处模拟网络延迟获得数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"bitCNY_ETH" ofType:@""];
        NSData *klineData = [[NSData alloc] initWithContentsOfFile:dataPath];
        
        NSLog(@"KlineData length = %lu",(unsigned long)klineData.length);
        [strongSelf.fullKLineView.dataCenter cleanData];
        NSArray *dataArray = [KLineDataProcess convertToKlineModelArrayWithJsonData:klineData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 追加数据，并且合并数据
            [strongSelf.fullKLineView.dataCenter addMoreDataWithArray:dataArray isMergeModel:^BOOL(KLineModel * _Nonnull firstModel, KLineModel * _Nonnull secondModel) {
                // 如果返回YES表示需要合并，当前合并条件是两个元素的时间戳一致
                return [KLineDataProcess checkoutIsInSameTimeSectionWithFirstTime:firstModel.stamp secondTime:secondModel.stamp];
            }];
            
            [strongSelf.fullKLineView gl_stopAnimating];
            // 更新上方当前信息
            [strongSelf p_updateCurrentDetailData];
        });
    });
}

- (void)p_updateCurrentDetailData {
    KLineModel *tempModel = [[DataCenter shareCenter].klineModelArray lastObject];
    
    if (tempModel) {
        self.symbolLabel.text = @"ETH/bitCNY";
        self.currentPriceLabel.text = [@(tempModel.close) stringValue];
        self.currentPriceLabel.textColor = [UIColor colorWithHex:0xdf1958];
        // 计算并展示24h涨跌
        [self p_update24Hchange];
    }
}

/**
 计算并展示24h涨跌
 */
- (void)p_update24Hchange {
    
    NSMutableAttributedString *mutableAttri = [[NSMutableAttributedString alloc] initWithString:@"24h涨跌  " attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"-1.24%" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xdf1958],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    [mutableAttri appendAttributedString:attri];
    
    [self.hour_24_changeLabel setAttributedText:mutableAttri];
}

- (void)p_switchIndicatorWithSelectedTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath {
    
    if (!title || title.length < 1) {
        return;
    }
    
    if ([title isEqualToString:@"MA"]) {
        switch (self.fullKLineView.mainViewType) {
            case KLineMainViewTypeKLineWithMA:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
                [self.indicatorSelectView setSelectedState:NO forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
            }
                break;
            case KLineMainViewTypeTimeLine:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLineWithMA];
                [self.indicatorSelectView setSelectedState:YES forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
            }
                break;
            case KLineMainViewTypeTimeLineWithMA:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLine];
                [self.indicatorSelectView setSelectedState:NO forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
            }
                break;
                
            default:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithMA];
                [self.indicatorSelectView setSelectedState:YES forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
            }
                break;
        }
        
    }else if([title isEqualToString:@"BOLL"]){
        if (self.fullKLineView.mainViewType == KLineMainViewTypeKLineWithBOLL) {
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
            [self.indicatorSelectView setSelectedState:NO forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }else {
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithBOLL];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }
    }else if([title isEqualToString:@"KDJ"]) {
        if (self.fullKLineView.assistantViewType == KLineAssistantViewTypeKDJ) {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeVolWithMA];
            [self.indicatorSelectView setSelectedState:NO forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }else {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeKDJ];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }
    }else if([title isEqualToString:@"MACD"]) {
        if (self.fullKLineView.assistantViewType == KLineAssistantViewTypeMACD) {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeVolWithMA];
            [self.indicatorSelectView setSelectedState:NO forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }else {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeMACD];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }
    }else if([title isEqualToString:@"RSI"]) {
        
        if (self.fullKLineView.assistantViewType == KLineAssistantViewTypeRSI) {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeVolWithMA];
            [self.indicatorSelectView setSelectedState:NO forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }else {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeRSI];
            [self.indicatorSelectView setSelectedState:YES forIndexPath:indexPath cleanOtherItemCurrentSection:YES];
        }
    }
}

/**
 收回选择视图
 */
- (void)p_hideSelectedView {
    
    if (_timeSelectView) {
        [self.timeSelectView removeFromSuperview];
        NSString *newHourTitle = [self.hourBtn.currentTitle stringByReplacingOccurrencesOfString:@"▲" withString:@"▼"];
        [self.hourBtn setTitle:newHourTitle forState:UIControlStateNormal];
        
        NSString *newMinuteTitle = [self.minuteBtn.currentTitle stringByReplacingOccurrencesOfString:@"▲" withString:@"▼"];
        [self.minuteBtn setTitle:newMinuteTitle forState:UIControlStateNormal];
        
    }
}

/**
 展示选择视图
 
 @param btn 需要展示选择视图的按钮
 */
- (void)p_showSelectedViewWithBtn:(UIButton *)btn {
    
    [self.backView addSubview:self.timeSelectView];
    [self.timeSelectView updateIdentifier:btn.currentTitle];
    
    if (btn == self.minuteBtn) {
        
        self.timeSelectView.frame = CGRectMake(0, 0, 100.0f, 4*44.0f);
        [self.timeSelectView reloadListData];
        self.timeSelectView.tag = self.minuteBtn.tag;
        [self.timeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.minuteBtn.mas_top);
            make.centerX.equalTo(self.minuteBtn.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100.0f, 4 * 44.0f));
        }];
        
        NSString *newMinuteTitle = [self.minuteBtn.currentTitle stringByReplacingOccurrencesOfString:@"▼" withString:@"▲"];
        [self.minuteBtn setTitle:newMinuteTitle forState:UIControlStateNormal];
        
    }else if(btn == self.hourBtn) {
        
        self.timeSelectView.frame = CGRectMake(0, 0, 100.0f, 5*44.0f);
        [self.timeSelectView reloadListData];
        self.timeSelectView.tag = self.hourBtn.tag;
        [self.timeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.hourBtn.mas_top);
            make.centerX.equalTo(self.hourBtn.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100.0f, 5 * 44.0f));
        }];
        
        NSString *newHourTitle = [self.hourBtn.currentTitle stringByReplacingOccurrencesOfString:@"▼" withString:@"▲"];
        [self.hourBtn setTitle:newHourTitle forState:UIControlStateNormal];
    }
}

/**
 设置选中状态

 @param btn 设置选中状态的按钮
 */
- (void)p_setSelectedStateForBtn:(UIButton *)btn {
    
    for (UIButton *tmpBtn in self.bottomBtnArray) {
        if (tmpBtn.tag == btn.tag) {
            [tmpBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        }else {
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 懒加载 ---

- (FullScreenKLineView *)fullKLineView {
    
    if (!_fullKLineView) {
        _fullKLineView = [[FullScreenKLineView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, SCREEN_HEIGHT - 50.0f, SCREEN_WIDTH - 100.0f)];
    }
    return _fullKLineView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
        _backView.backgroundColor = [UIColor darkGrayColor];
        [_backView addGestureRecognizer:self.backTapGesture];
    }
    return _backView;
}

- (UITapGestureRecognizer *)backTapGesture {
    if (!_backTapGesture) {
        _backTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_backViewTapAction:)];
        _backTapGesture.delegate = self;
    }
    return _backTapGesture;
}

- (UILabel *)symbolLabel {
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 50.0f)];
        _symbolLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _symbolLabel.text = @"--/--";
    }
    return _symbolLabel;
}

- (UILabel *)currentPriceLabel {
    if (!_currentPriceLabel) {
        _currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 50.0f)];
        _currentPriceLabel.font = [UIFont systemFontOfSize:15.0f];
        _currentPriceLabel.text = @"--";
    }
    return _currentPriceLabel;
}

- (UILabel *)hour_24_changeLabel {
    if (!_hour_24_changeLabel) {
        _hour_24_changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 50.0f)];
        _hour_24_changeLabel.font = [UIFont systemFontOfSize:17.0];
    }
    return _hour_24_changeLabel;
}

- (UIButton *)quitBtn {
    if (!_quitBtn) {
        _quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 50.0f)];
        [_quitBtn setTitle:@"❌" forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(p_quitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

- (ListMenuView *)indicatorSelectView {
    if (!_indicatorSelectView) {
        _indicatorSelectView = [[ListMenuView alloc] initWithFrame:CGRectZero identifier:@"indicatorSelectView"];
        _indicatorSelectView.delegate = self;
    }
    return _indicatorSelectView;
}

- (ListMenuView *)timeSelectView {
    if (!_timeSelectView) {
        _timeSelectView = [[ListMenuView alloc] initWithFrame:CGRectZero identifier:self.minuteBtn.currentTitle];
        _timeSelectView.backgroundColor = [UIColor blackColor];
        _timeSelectView.isShowSeparator = YES;
        _timeSelectView.delegate = self;
    }
    return _timeSelectView;
}

- (UIButton *)timeLineBtn {
    
    if (!_timeLineBtn) {
        _timeLineBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeLineBtn setTitle:@"分时" forState:UIControlStateNormal];
        _timeLineBtn.tag = kBaseBtnTag + 0;
        [_timeLineBtn addTarget:self action:@selector(p_timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeLineBtn;
}

- (UIButton *)dayLineBtn {
    
    if (!_dayLineBtn) {
        _dayLineBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_dayLineBtn setTitle:@"日线" forState:UIControlStateNormal];
        _dayLineBtn.tag = kBaseBtnTag + 1;
        [_dayLineBtn addTarget:self action:@selector(p_timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dayLineBtn;
}

- (UIButton *)weekLineBtn {
    
    if (!_weekLineBtn) {
        _weekLineBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_weekLineBtn setTitle:@"周线" forState:UIControlStateNormal];
        _weekLineBtn.tag = kBaseBtnTag + 2;
        [_weekLineBtn addTarget:self action:@selector(p_timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weekLineBtn;
}
//▲
- (UIButton *)hourBtn{
    if (!_hourBtn) {
        _hourBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_hourBtn setTitle:@"小时 ▼" forState:UIControlStateNormal];
        _hourBtn.tag = kBaseBtnTag + 3;
        [_hourBtn addTarget:self action:@selector(p_timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hourBtn;
}

- (UIButton *)minuteBtn {
    if (!_minuteBtn) {
        _minuteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_minuteBtn setTitle:@"分钟 ▼" forState:UIControlStateNormal];
        _minuteBtn.tag = kBaseBtnTag + 4;
        [_minuteBtn addTarget:self action:@selector(p_timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minuteBtn;
}

- (NSArray *)bottomBtnArray {
    if (!_bottomBtnArray) {
        _bottomBtnArray = @[self.timeLineBtn,self.dayLineBtn,self.weekLineBtn,self.hourBtn,self.minuteBtn];
    }
    return _bottomBtnArray;
}

@end
