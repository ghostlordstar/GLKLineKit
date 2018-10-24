//
//  GLConstantDefinition.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 一些常量定义 */

#ifndef GLConstantDefinition_h
#define GLConstantDefinition_h
#import <UIKit/UIKit.h>

#pragma mark - 最大最小值的结构体 ----👇👇--begin----
// 最值结构体定义
struct GLExtremeValue {
    double minValue;
    double maxValue;
};
typedef struct CG_BOXABLE GLExtremeValue GLExtremeValue;

// 最值都是0的结构体
CG_EXTERN GLExtremeValue const GLExtremeValueZero;

// 定义创建结构体方法
CG_INLINE GLExtremeValue GLExtremeValueMake(double minValue, double maxValue);

CG_INLINE GLExtremeValue GLExtremeValueMake(double minValue, double maxValue)
{
    GLExtremeValue e; e.minValue = minValue; e.maxValue = maxValue; return e;
}

// 定义并实现比较两个最值结构体的方法
CG_EXTERN bool GLExtremeValueEqualToExtremeValue(GLExtremeValue value1, GLExtremeValue value2);
CG_INLINE bool
__GLExtremeValueEqualToExtremeValue(GLExtremeValue value1, GLExtremeValue value2)
{
    return value1.minValue == value2.minValue && value1.maxValue == value2.maxValue;
}
#define GLExtremeValueEqualToExtremeValue __GLExtremeValueEqualToExtremeValue

#pragma mark -- 最大最小值的结构体 ----👆👆--end----



#pragma mark - block 定义 -----------------
/* 更新最大最小值的block */
typedef void (^UpdateExtremeValueBlock)(NSString *identifier , double minValue,double maxValue);


#pragma mark - 一些Key的定义 ---------------
/* 在字典中保存时对应的Key */
UIKIT_EXTERN NSString *const updateExtremeValueBlockAtDictionaryKey;

/* K线绘图算法默认的Identifier */
UIKIT_EXTERN NSString *const klineDrawLogicDefaultIdentifier;

/* K线背景绘图算法默认的Identifier */
UIKIT_EXTERN NSString *const klineBGDrawLogicDefaultIdentifier;

/* k线视图传入背景绘图算法的最大最小值的key */
UIKIT_EXTERN NSString *const KlineViewToKlineBGDrawLogicExtremeValueKey;

/* 十字线选中的model的key */
UIKIT_EXTERN NSString *const KlineViewReticleSelectedModelKey;

#endif /* ConstantDefinition_h */
