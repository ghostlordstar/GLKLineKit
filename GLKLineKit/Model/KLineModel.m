//
//  KLineModel.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/4/28.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineModel.h"
#import "DataCenter.h"
@implementation KLineModel

/**
 根据数据数组创建对象
 
 @param dataArray 数据数组
 */
+ (instancetype)createWithArray:(NSArray *)dataArray {
    KLineModel *tempModel = nil;
//    NSAssert(dataArray.count >= 6, @"create kline model need array.count >= 6");
    if (dataArray && dataArray.count >= 6) {
        
        // 根据传入数据设置小数点位数
        if([DataCenter shareCenter].decimalsLimit < 0) {
            // 计算传来的数小数点位数
            NSString *tempClose = dataArray[2];
            if (tempClose && [tempClose isKindOfClass:[NSString class]]) {
                if ([tempClose containsString:@"."]) {
                    NSArray *tempArray = [tempClose componentsSeparatedByString:@"."];
                    NSUInteger deci = [[tempArray lastObject] length];
                    [DataCenter shareCenter].decimalsLimit = deci;
                }else {
                    [DataCenter shareCenter].decimalsLimit = 0;
                }
            }
        }
        
        for (int a = 0; a < dataArray.count; a ++) {
            tempModel = [KLineModel new];
            tempModel.stamp = [dataArray[0] doubleValue];
            tempModel.open = [dataArray[1] doubleValue];
            tempModel.close = [dataArray[2] doubleValue];
            tempModel.high = [dataArray[3] doubleValue];
            tempModel.low = [dataArray[4] doubleValue];
            tempModel.volume = [dataArray[5] doubleValue];
        }
    }
    return tempModel;
}

@end
