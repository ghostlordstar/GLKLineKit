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
@interface LandscapeController ()
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

- (void)p_quitBtnAction:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
