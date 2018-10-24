//
//  ExamplePubliEnum.h
//  GLKLineKit
//
//  Created by walker on 2018/5/30.
//  Copyright © 2018年 walker. All rights reserved.
//

#ifndef ExamplePubliEnum_h
#define ExamplePubliEnum_h
/* K线主图样式 */
typedef enum : NSUInteger {
    KLineMainViewTypeKLine = 1,     // K线图(蜡烛图)
    KLineMainViewTypeKLineWithMA,   // K线图包含MA
    KLineMainViewTypeTimeLine,      // 分时图
    KLineMainViewTypeTimeLineWithMA,// 分时图包含MA
    KLineMainViewTypeKLineWithBOLL, // K线图包含BOLL指数
} KLineMainViewType;

/* K线附图样式 */
typedef enum : NSUInteger {
    KLineAssistantViewTypeVol = 1,      // 成交量
    KLineAssistantViewTypeVolWithMA,    // 成交量包含MA
    KLineAssistantViewTypeKDJ,          // KDJ
    KLineAssistantViewTypeMACD,         // MACD
    KLineAssistantViewTypeRSI,          // RSI
} KLineAssistantViewType;


#endif /* ExamplePubliEnum_h */
