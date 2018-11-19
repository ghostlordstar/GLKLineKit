//
//  PortraitTestController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "PortraitTestController.h"
#import "SimpleKLineVolView.h"
#import "KLineDataProcess.h"

@interface PortraitTestController ()

/**
 简单行情视图
 */
@property (strong, nonatomic) SimpleKLineVolView *simpleKLineView;

/**
 分时切换按钮
 */
@property (strong, nonatomic) UIButton *timeBtn;

/**
 K线切换按钮
 */
@property (strong, nonatomic) UIButton *klineBtn;

@end

@implementation PortraitTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self p_initialize];
    // 设置UI
    [self p_setUpUI];
    // 获得K线数据
    [self p_getDataToKline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 控件事件 ---

- (void)btnAction:(UIButton *)btn {
    
    if (btn.tag == 8805) {
        // 分时
        [self.simpleKLineView switchKLineMainViewToType:KLineMainViewTypeTimeLine];
    }else if(btn.tag == 8806) {
        // K线
        [self.simpleKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
    }
}

#pragma  mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = KLocalizedString(@"kline_demo_portrait", @"竖屏");
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)p_setUpUI {
    
    [self.view addSubview:self.simpleKLineView];
    
    [self.view addSubview:self.klineBtn];
    [self.view addSubview:self.timeBtn];
}

- (void)p_getDataToKline {
    
    [self.simpleKLineView gl_startAnimating];
    
    __weak typeof(self)weakSelf = self;
    // 此处模拟网络延迟获得数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"BTC_USDT_2h" ofType:@"json"];
        NSData *klineData = [[NSData alloc] initWithContentsOfFile:dataPath];

        NSLog(@"KlineData length = %lu",(unsigned long)klineData.length);
        [strongSelf.simpleKLineView.dataCenter cleanData];
        NSArray *dataArray = [KLineDataProcess convertToKlineModelArrayWithJsonData:klineData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 追加数据，并且合并数据
            [strongSelf.simpleKLineView.dataCenter addMoreDataWithArray:dataArray isMergeModel:^BOOL(KLineModel * _Nonnull firstModel, KLineModel * _Nonnull secondModel) {
                // 如果返回YES表示需要合并，当前合并条件是两个元素的时间戳一致
                return [KLineDataProcess checkoutIsInSameTimeSectionWithFirstTime:firstModel.stamp secondTime:secondModel.stamp];
            }];
            
            [strongSelf.simpleKLineView gl_stopAnimating];
        });
    });
    
}

#pragma mark - 懒加载 ----

- (SimpleKLineVolView *)simpleKLineView {
    if (!_simpleKLineView) {
        _simpleKLineView = [[SimpleKLineVolView alloc] initWithFrame:CGRectMake(10.0f, 100.0, SCREEN_WIDTH - 20.0f, 300.0f)];
        [_simpleKLineView switchKLineMainViewToType:KLineMainViewTypeKLine];
    }
    return _simpleKLineView;
}

- (UIButton *)timeBtn {
    
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, SCREEN_HEIGHT - 150, 100, 30)];
        [_timeBtn setTitle:KLocalizedString(@"kline_demo_timeLine", @"分时") forState:UIControlStateNormal];
        [_timeBtn setTag:8805];
        [_timeBtn setBackgroundColor:[UIColor grayColor]];
        [_timeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (UIButton *)klineBtn {
    
    if (!_klineBtn) {
        _klineBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, SCREEN_HEIGHT - 150, 100, 30)];
        [_klineBtn setTitle:KLocalizedString(@"kline_demo_Kline", @"k线") forState:UIControlStateNormal];
        [_klineBtn setTag:8806];
        [_klineBtn setBackgroundColor:[UIColor grayColor]];
        [_klineBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _klineBtn;
}

@end
