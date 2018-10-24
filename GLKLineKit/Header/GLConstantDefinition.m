//
//  GLConstantDefinition.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "GLConstantDefinition.h"
/* 在字典中保存时对应的Key */
NSString *const updateExtremeValueBlockAtDictionaryKey = @"updateExtremeValueBlockAtDictionaryKey";
/* K线绘图算法默认的Identifier */
NSString *const klineDrawLogicDefaultIdentifier = @"klineDrawLogicDefaultIdentifier";
/* K线背景绘图算法默认的Identifier */
NSString *const klineBGDrawLogicDefaultIdentifier = @"klineBGDrawLogicDefaultIdentifier";
/* k线视图传入背景绘图算法的最大最小值的key */
NSString *const KlineViewToKlineBGDrawLogicExtremeValueKey = @"KlineViewToKlineBGDrawLogicExtremeValueKey";
/* 十字线选中的model的key */
NSString  *const KlineViewReticleSelectedModelKey = @"KlineViewReticleSelectedModelKey";

GLExtremeValue const GLExtremeValueZero = {0,0};
