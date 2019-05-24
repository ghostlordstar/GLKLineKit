//
//  GLConstantDefinition.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "GLConstantDefinition.h"

// ---- 在字典中保存时对应的Key -------
/* 更新最值的block */
NSString *const updateExtremeValueBlockAtDictionaryKey = @"updateExtremeValueBlockAtDictionaryKey";

/* K线绘图算法默认的Identifier */
NSString *const klineDrawLogicDefaultIdentifier = @"klineDrawLogicDefaultIdentifier";

/* K线背景绘图算法默认的Identifier */
NSString *const klineBGDrawLogicDefaultIdentifier = @"klineBGDrawLogicDefaultIdentifier";

/* k线视图传入背景绘图算法的最大最小值的key */
NSString *const KlineViewToKlineDrawLogicExtremeValueArrayKey = @"KlineViewToKlineDrawLogicExtremeValueArrayKey";

/* 十字线选中的model位置Index的key */
NSString  *const KlineViewReticleSelectedModelIndexKey = @"KlineViewReticleSelectedModelIndexKey";

/* K线视图上触摸点集合的key */
NSString  *const KlineViewTouchPointValueArrayKey = @"KlineViewTouchPointValueArrayKey";

GLExtremeValue const GLExtremeValueZero = {0.0f,0.0f};
