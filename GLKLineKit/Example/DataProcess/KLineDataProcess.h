//
//  KLineDataProcess.h
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineDataProcess : NSObject

/**
 将k线json转换为模型数组
 
 @param jsonData json数据
 @return 模型数组
 */
+ (NSMutableArray * _Nullable)convertToKlineModelArrayWithJsonData:(NSData * _Nonnull)jsonData;

/**
 检测两个时间戳是否一致
 
 @param firstStamp 第一个时间戳
 @param secondStamp 第二个时间戳
 @return 是否相同
 */
+ (BOOL)checkoutIsInSameTimeSectionWithFirstTime:(NSTimeInterval)firstStamp secondTime:(NSTimeInterval)secondStamp;

@end
