//
//  KLineDataProcess.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "KLineDataProcess.h"

@implementation KLineDataProcess
/**
 将k线json转换为模型数组
 
 @param jsonData json数据
 @return 模型数组
 */
+ (NSMutableArray * _Nullable)convertToKlineModelArrayWithJsonData:(NSData * _Nonnull)jsonData {
    NSMutableArray *resultArray = @[].mutableCopy;
    // 设置前置的下标
    BOOL isNeedRestIndex = NO;
    __block NSInteger lastIndex = 0;
    if([DataCenter shareCenter].klineModelArray.count) {
        isNeedRestIndex = NO;
        lastIndex = [(KLineModel *)[[DataCenter shareCenter].klineModelArray lastObject] index];
    }else {
        isNeedRestIndex = YES;
    }
    // 解析
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (!error) {
        // 解析成功
       // NSLog(@"数据量：%lu,%@",(unsigned long)jsonArray.count,jsonArray);
        if(jsonArray.count >= 6 && ![[jsonArray firstObject] isKindOfClass:[NSArray class]]) {
            jsonArray = @[jsonArray];
        }
        
        [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KLineModel *tempModel = [KLineModel createWithArray:obj];
            if (tempModel) {
                
                tempModel.index = lastIndex + idx;
                [resultArray addObject:tempModel];
            }
        }];
    }
    return resultArray;
}

/**
 检测两个时间戳是否一致
 
 @param firstStamp 第一个时间戳
 @param secondStamp 第二个时间戳
 @return 是否相同
 */
+ (BOOL)checkoutIsInSameTimeSectionWithFirstTime:(NSTimeInterval)firstStamp secondTime:(NSTimeInterval)secondStamp {
    
    BOOL isSame = NO;
    
    if (firstStamp == secondStamp) {
        isSame = YES;
    }
    return isSame;
}

@end
