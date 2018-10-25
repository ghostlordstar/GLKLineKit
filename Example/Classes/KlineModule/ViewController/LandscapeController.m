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


#define kBaseBtnTag (7893)

@interface LandscapeController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
/** 横屏行情视图 */
@property (strong, nonatomic) FullScreenKLineView *fullKLineView;

/** 底图 */
@property (strong, nonatomic) UIView *backView;

/** 交易对名称 */
@property (strong, nonatomic) UILabel *symbolLabel;

/** currentPrice */
@property (strong, nonatomic) UILabel *currentPriceLabel;

/** 24h涨跌 */
@property (strong, nonatomic) UILabel *hour_24_changeLabel;

/** 关闭按钮 */
@property (strong, nonatomic) UIButton *quitBtn;

/** K线按钮 */
@property (strong, nonatomic) UIButton *kLineBtn;

/** 分时按钮 */
@property (strong, nonatomic) UIButton *timeLineBtn;

/** 背景视图手势 */
@property (strong, nonatomic) UITapGestureRecognizer *backTapGesture;

/** 指标选择 */
@property (strong, nonatomic) UITableView *indicatorListView;

/** 指标列表集合 */
@property (strong, nonatomic) NSArray *indicatorArray;

/** 点击选中的cell的位置 */
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@end

static NSString *const indicatorListView_cell_id_1 = @"indicatorListView_cell_id_1";
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

/**
 退出按钮事件
 
 @param btn 退出按钮
 */
- (void)p_quitBtnAction:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 分时图
 
 @param btn 切换按钮
 */
- (void)p_timeBtnAction:(UIButton *)btn {
    
    [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLineWithMA];
    [self.timeLineBtn setBackgroundColor:KColorBackGround];
    [self.timeLineBtn setTitleColor:KColorTheme forState:UIControlStateNormal];
    [self.kLineBtn setBackgroundColor:KColorText_000000];
    [self.kLineBtn setTitleColor:KColorBackGround forState:UIControlStateNormal];
}

/**
 K线图
 
 @param btn k线图切换按钮
 */
- (void)p_klineBtnAction:(UIButton *)btn {
    
    [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithMA];
    [self.kLineBtn setBackgroundColor:KColorBackGround];
    [self.kLineBtn setTitleColor:KColorTheme forState:UIControlStateNormal];
    [self.timeLineBtn setBackgroundColor:KColorText_000000];
    [self.timeLineBtn setTitleColor:KColorBackGround forState:UIControlStateNormal];
}


#pragma mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = KLocalizedString(@"kline_demo_landscape", @"横屏样式");
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
    [self.backView addSubview:self.timeLineBtn];
    [self.backView addSubview:self.kLineBtn];
    [self.backView addSubview:self.indicatorListView];
    
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
    
    [self.timeLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.fullKLineView.frame.size.width / 2.0f);
    }];
    
    [self.kLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLineBtn.mas_right);
        make.top.equalTo(self.fullKLineView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.width.mas_equalTo(self.fullKLineView.frame.size.width / 2.0f);
    }];
    
    [self.indicatorListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.fullKLineView.mas_right);
        make.right.equalTo(self.backView.mas_right);
        make.top.equalTo(self.quitBtn.mas_bottom).offset(5.0f);
        make.bottom.equalTo(self.backView.mas_bottom);
    }];
    
}

/**
 对视图进行旋转
 */
- (void)p_transFormBackView {
    
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
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
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"BTC_USDT_2h" ofType:@"json"];
        NSData *klineData = [[NSData alloc] initWithContentsOfFile:dataPath];
        
        NSLog(@"KlineData length = %lu",(unsigned long)klineData.length);
        [strongSelf.fullKLineView.dataCenter cleanData];// 清空数据中心的数据
        NSArray *dataArray = [KLineDataProcess convertToKlineModelArrayWithJsonData:klineData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 追加数据，并且合并数据
            [strongSelf.fullKLineView.dataCenter addMoreDataWithArray:dataArray isMergeModel:^BOOL(KLineModel * _Nonnull firstModel, KLineModel * _Nonnull secondModel) {
                // 如果返回YES表示需要合并，当前合并条件是两个元素的时间戳一致
                return [KLineDataProcess checkoutIsInSameTimeSectionWithFirstTime:firstModel.stamp secondTime:secondModel.stamp];
            }];
            // 隐藏加载动画
            [strongSelf.fullKLineView gl_stopAnimating];
            // 更新上方当前信息
            [strongSelf p_updateCurrentDetailData];
        });
    });
}

- (void)p_updateCurrentDetailData {
    KLineModel *tempModel = [[DataCenter shareCenter].klineModelArray lastObject];
    
    if (tempModel) {
        self.symbolLabel.text = @"BTC/USDT";
        self.currentPriceLabel.text = [@(tempModel.close) stringValue];
        self.currentPriceLabel.textColor = [UIColor colorWithHex:0xdf1958];
        // 计算并展示24h涨跌
        [self p_update24Hchange];
        [self p_klineBtnAction:nil];
    }
}

/**
 计算并展示24h涨跌
 */
- (void)p_update24Hchange {
    
    NSMutableAttributedString *mutableAttri = [[NSMutableAttributedString alloc] initWithString:KLocalizedString(@"kline_demo_24change", @"24h涨跌") attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"-1.24%" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xdf1958],NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    [mutableAttri appendAttributedString:attri];
    
    [self.hour_24_changeLabel setAttributedText:mutableAttri];
}


/**
 切换指标方法
 
 @param title 指标名称
 */
- (void)p_switchIndicatorWithSelectedTitle:(NSString *)title indexPath:(NSIndexPath *)indexPath {
    
    if (!title || title.length < 1) {
        return;
    }
    
    if ([title isEqualToString:@"MA"]) {
        switch (self.fullKLineView.mainViewType) {
            case KLineMainViewTypeKLineWithMA:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
            }
                break;
            case KLineMainViewTypeTimeLine:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLineWithMA];
            }
                break;
            case KLineMainViewTypeTimeLineWithMA:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLine];
            }
                break;
                
            default:
            {
                [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithMA];
            }
                break;
        }
        
    }else if([title isEqualToString:@"BOLL"]){
        if (self.fullKLineView.mainViewType == KLineMainViewTypeKLineWithBOLL) {
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
        }else {
            [self.fullKLineView switchKLineMainViewToType:KLineMainViewTypeKLineWithBOLL];
        }
    }else if([title isEqualToString:@"KDJ"]) {
        if (self.fullKLineView.assistantViewType == KLineAssistantViewTypeKDJ) {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeVolWithMA];
        }else {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeKDJ];
        }
    }else if([title isEqualToString:@"MACD"]) {
        if (self.fullKLineView.assistantViewType == KLineAssistantViewTypeMACD) {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeVolWithMA];
        }else {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeMACD];
        }
    }else if([title isEqualToString:@"RSI"]) {
        
        if (self.fullKLineView.assistantViewType == KLineAssistantViewTypeRSI) {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeVolWithMA];
        }else {
            [self.fullKLineView switchKlineAssistantViewToType:KLineAssistantViewTypeRSI];
        }
    }
}

#pragma mark - listViewdelegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indicatorArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section < self.indicatorArray.count) {
        count = [[self.indicatorArray objectAtIndex:section] count];
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indicatorListView_cell_id_1 forIndexPath:indexPath];
    
    NSString *string = @"";
    
    string = [[self.indicatorArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = string;
    cell.textLabel.textColor = KColorTipText_999;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndexPath = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self p_switchIndicatorWithSelectedTitle:cell.textLabel.text indexPath:indexPath];
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
        _backView.backgroundColor = KColorGap;
    }
    return _backView;
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

- (UIButton *)timeLineBtn {
    
    if (!_timeLineBtn) {
        _timeLineBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeLineBtn setTitle:KLocalizedString(@"kline_demo_timeLine", @"分时") forState:UIControlStateNormal];
        [_timeLineBtn setBackgroundColor:KColorText_000000];
        _timeLineBtn.tag = kBaseBtnTag + 0;
        [_timeLineBtn addTarget:self action:@selector(p_timeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeLineBtn;
}

- (UIButton *)kLineBtn {
    if (!_kLineBtn) {
        _kLineBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_kLineBtn setTitle:KLocalizedString(@"kline_demo_Kline", @"k线")  forState:UIControlStateNormal];
        [_kLineBtn setBackgroundColor:KColorText_000000];
        _kLineBtn.tag = kBaseBtnTag + 4;
        [_kLineBtn addTarget:self action:@selector(p_klineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kLineBtn;
}

- (UITableView *)indicatorListView {
    if (!_indicatorListView) {
        _indicatorListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _indicatorListView.backgroundColor = [UIColor clearColor];
        _indicatorListView.delegate = self;
        _indicatorListView.dataSource = self;
        _indicatorListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_indicatorListView registerClass:[UITableViewCell class] forCellReuseIdentifier:indicatorListView_cell_id_1];
    }
    return _indicatorListView;
}

- (NSArray *)indicatorArray {
    
    if (!_indicatorArray) {
        _indicatorArray = @[@[@"MA",@"BOLL"],@[@"KDJ",@"MACD",@"RSI"]];
    }
    return _indicatorArray;
}

@end

