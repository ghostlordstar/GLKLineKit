//
//  NSString+GLDate.m
//  GLKLineKit
//
//  Created by walker on 2018/5/26.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "NSString+GLDate.h"

@implementation NSString (GLDate)

/**
 根据传入的格式将时间戳转换为响应的字符串
 
 @param timeStamp 时间戳(秒)
 @param formatterString 格式字符串
 @return 转换后的日期
 */
+ (NSString * _Nullable)gl_convertTimeStamp:(NSTimeInterval)timeStamp toFormatter:(NSString *)formatterString {
    
    NSString *result = @"";
    // 生成NSDate对象
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    // 生成日期格式对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // 设置格式
    if (formatterString && formatterString.length >= 1) {
        [dateFormatter setDateFormat:formatterString];
    }
    // 根据格式导出日期
    result = [dateFormatter stringFromDate:date];
    return result;
}

@end
