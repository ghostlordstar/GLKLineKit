//
//  NewSimpleKlineView.m
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/2/11.
//  Copyright © 2019 walker. All rights reserved.
//

#import "NewSimpleKlineView.h"
#import "KLineViewConfig.h"
#import "KLineAssistantConfig.h"

@interface NewSimpleKlineView ()

/** mainViewConfig */
@property (strong, nonatomic) KLineViewConfig *mainViewConfig;

/** VolViewConfig */
@property (strong, nonatomic) KLineAssistantConfig *volViewConfig;

/** 当前的主图样式 */
@property (assign, nonatomic) KLineMainViewType mainViewType;

@end

@implementation NewSimpleKlineView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self p_initialize];
        
        [self p_setUpUI];
    }
    return self;
}


#pragma mark - 初始化等方法 -------

- (void)p_initialize {
    
    self.backgroundColor = KColorBackGround;
    
    // 默认显示K线样式
    self.mainViewType = KLineMainViewTypeKLineWithMA;
    //    // 添加代理
    //    [self.kLineMainView.dataLogic addDelegate:self];
    //    [self.dataCenter addDelegate:self];
}

- (void)p_setUpUI {
    
    [self addSubview:self.kLineMainView];
    
    [self p_layout];
}

- (void)p_layout {
    
    [self.kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

#pragma mark - 公共方法 -----

/**
 切换主图样式
 */
- (void)switchKLineMainViewToType:(KLineMainViewType)type {
    
    if (type && type != self.mainViewType) {
        self.mainViewType = type;
        
        switch (type) {
                
            case KLineMainViewTypeKLine:    // 只有K线
            {
                [self.kLineMainView removeAllDrawLogic];
                
                // 主图 ------
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_bg" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineTimeDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"time" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineDateDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 100.0f, self.frame.size.width, 20.0f) drawLogicIdentifier:@"date" graphType:GraphTypeMain]];
//                [self.kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"k_line" graphType:GraphTypeMain]];
                //                [self.kLineMainView addDrawLogic:[[KLineMADrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_ma_5_10_30" graphType:GraphTypeMain]];
                //                [self.kLineMainView addDrawLogic:[[KLineBOLLDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_boll" graphType:GraphTypeMain]];
                // 副图 ---------
                KLineBGDrawLogic *assistantBgLogic = [[KLineBGDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"assistant_bg" graphType:GraphTypeAssistant];
                assistantBgLogic.isHideMidDial = YES;
                [assistantBgLogic updateConfig:self.volViewConfig];
                [self.kLineMainView addDrawLogic:assistantBgLogic];
                
                //                KLineVolDrawLogic *volLogic = [[KLineVolDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol" graphType:GraphTypeAssistant];
                //                [volLogic updateConfig:self.volViewConfig];
                //                [self.kLineMainView addDrawLogic:volLogic];
                //
                //                KLineVolMADrawLogic *volMaLogic = [[KLineVolMADrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol_ma" graphType:GraphTypeAssistant];
                //                [volMaLogic updateConfig:self.volViewConfig];
                //                [self.kLineMainView addDrawLogic:volMaLogic];
                
//                KLineMACDDrawLogic *macdLogic = [[KLineMACDDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"macd" graphType:GraphTypeAssistant];
//                [macdLogic updateConfig:self.volViewConfig];
//                [self.kLineMainView addDrawLogic:macdLogic];
                
//                KLineRSIDrawLogic *rsiLogic = [[KLineRSIDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"rsi" graphType:GraphTypeAssistant];
//                [rsiLogic updateConfig:self.volViewConfig];
//                [self.kLineMainView addDrawLogic:rsiLogic];
                
                KLineKDJDrawLogic *kdjLogic = [[KLineKDJDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"kdj" graphType:GraphTypeAssistant];
                [kdjLogic updateConfig:self.volViewConfig];
                [self.kLineMainView addDrawLogic:kdjLogic];

            }
                break;
                
                
            case KLineMainViewTypeKLineWithMA:  // K线+MA
            {// 主图切为分时蜡烛图
                
                [self.kLineMainView removeAllDrawLogic];
                
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_bg" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"k_line" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineMADrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_ma_5_10_30" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineVolDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol" graphType:GraphTypeAssistant]];
                [self.kLineMainView addDrawLogic:[[KLineVolMADrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol_ma" graphType:GraphTypeAssistant]];
            }
                break;
                
            case  KLineMainViewTypeTimeLine:    // 只有分时线
            {
                [self.kLineMainView removeAllDrawLogic];
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_bg" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineTimeDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_time" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineVolDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol" graphType:GraphTypeAssistant]];
                [self.kLineMainView addDrawLogic:[[KLineVolMADrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol_ma" graphType:GraphTypeAssistant]];
            }
                break;
                
                
            case KLineMainViewTypeTimeLineWithMA:   // 分时线+MA
            {  // 主图样式切换为分时图
                
                [self.kLineMainView removeAllDrawLogic];
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_bg" graphType:GraphTypeMain]];
                [self.kLineMainView addDrawLogic:[[KLineTimeDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_time" graphType:GraphTypeMain]];
                KLineMADrawLogic *timeMA = [[KLineMADrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_time_ma_30" graphType:GraphTypeMain];
                [timeMA setMa5Hiden:YES];
                [timeMA setMa10Hiden:YES];
                [self.kLineMainView addDrawLogic:timeMA];
                
                [self.kLineMainView addDrawLogic:[[KLineVolDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol" graphType:GraphTypeAssistant]];
                [self.kLineMainView addDrawLogic:[[KLineVolMADrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol_ma" graphType:GraphTypeAssistant]];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 懒加载 ---------

- (KLineView *)kLineMainView {
    if (!_kLineMainView) {
        _kLineMainView = [[KLineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - 20.0f) * 7.0/10.0) config:self.mainViewConfig];
        _kLineMainView.backgroundColor = KColorBackGround;
        // 添加绘图算法
        [_kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"k_line" graphType:GraphTypeMain]];
        [_kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_bg" graphType:GraphTypeMain]];
        [_kLineMainView addDrawLogic:[[KLineMADrawLogic alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 100.0f) drawLogicIdentifier:@"main_ma_5_10_30" graphType:GraphTypeMain]];
        [_kLineMainView addDrawLogic:[[KLineVolDrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol" graphType:GraphTypeAssistant]];
        [_kLineMainView addDrawLogic:[[KLineVolMADrawLogic alloc] initWithRect:CGRectMake(0, self.frame.size.height - 80.0f, self.frame.size.width, 80.0f) drawLogicIdentifier:@"vol_ma" graphType:GraphTypeAssistant]];
    }
    return _kLineMainView;
}

- (KLineViewConfig *)mainViewConfig {
    if (!_mainViewConfig) {
        _mainViewConfig = [[KLineViewConfig alloc] init];
    }
    return _mainViewConfig;
}

- (KLineAssistantConfig *)volViewConfig {
    if (!_volViewConfig) {
        _volViewConfig = [[KLineAssistantConfig alloc] init];
    }
    return _volViewConfig;
}

- (DataCenter *)dataCenter {
    
    if (!_dataCenter) {
        _dataCenter = [self.kLineMainView dataCenter];
    }
    return _dataCenter;
}

@end
