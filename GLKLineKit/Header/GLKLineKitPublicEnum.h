//
//  GLKLineKitPublicEnum.h
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/2/12.
//  Copyright © 2019 walker. All rights reserved.
//

#ifndef GLKLineKitPublicEnum_h
#define GLKLineKitPublicEnum_h

/* 图形类型 */
typedef enum : NSUInteger {
    GraphTypeMain = 1,          // 主图
    GraphTypeAssistant,         // 副图
    GraphTypeFull,              // 全图(包括所有主图和所有副图)
}GraphType;

/* 对指标数据处理时选择的指标类型 */
typedef enum : NSUInteger {
    IndicatorsDataTypeNone = 1,         // 无处理，只有高，开，低，收，时间，量等初始数据，不进行其他数据的计算
    IndicatorsDataTypeMA,               // 价格MA(5,10,30)
    IndicatorsDataTypeVolMA,            // 成交量MA(5,10)
    IndicatorsDataTypeBOLL,             // BOLL
    IndicatorsDataTypeMACD,             // MACD
    IndicatorsDataTypeKDJ,              // KDJ
    IndicatorsDataTypeRSI,              // RSI
    //    IndicatorsDataTypeDate,             // 时间展示
} IndicatorsDataType;


#endif /* GLKLineKitPublicEnum_h */
