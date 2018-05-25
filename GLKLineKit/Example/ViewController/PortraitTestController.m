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

#pragma  mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"竖屏样式";
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)p_setUpUI {
    
    [self.view addSubview:self.simpleKLineView];
    
}

- (void)p_getDataToKline {
    
    __weak typeof(self)weakSelf = self;
    
    // 此处模拟网络延迟获得数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"bitCNY_ETH" ofType:@""];
        NSData *klineData = [[NSData alloc] initWithContentsOfFile:dataPath];

        NSLog(@"KlineData length = %lu",klineData.length);
        [strongSelf.simpleKLineView.dataCenter cleanData];
        
        NSArray *dataArray = [KLineDataProcess convertToKlineModelArrayWithJsonData:klineData];
        // 追加数据，并且合并数据
        [strongSelf.simpleKLineView.dataCenter addMoreDataWithArray:dataArray isMergeModel:^BOOL(KLineModel * _Nonnull firstModel, KLineModel * _Nonnull secondModel) {
            // 如果返回YES表示需要合并，当前合并条件是两个元素的时间戳一致
            return [KLineDataProcess checkoutIsInSameTimeSectionWithFirstTime:firstModel.stamp secondTime:secondModel.stamp];
        }];
    });
    
    
    
}

#pragma mark - 懒加载 ----

- (SimpleKLineVolView *)simpleKLineView {
    if (!_simpleKLineView) {
        _simpleKLineView = [[SimpleKLineVolView alloc] initWithFrame:CGRectMake(10.0f, 64.0, SCREEN_WIDTH - 20.0f, 300.0f)];
    }
    return _simpleKLineView;
}

@end
