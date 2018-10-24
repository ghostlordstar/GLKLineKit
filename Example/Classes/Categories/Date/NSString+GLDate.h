//
//  NSString+GLDate.h
//  GLKLineKit
//
//  Created by walker on 2018/5/26.
//  Copyright © 2018年 walker. All rights reserved.
//

/* 时间转换类目 */

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSString (GLDate)

// yyyy.MM.dd HH:mm:ss

/**
 根据传入的格式将时间戳转换为响应的字符串

 @param timeStamp 时间戳(秒)
 @param formatterString 格式字符串
 @return 转换后的日期
 */
+ (NSString * _Nullable)gl_convertTimeStamp:(NSTimeInterval)timeStamp toFormatter:(NSString *)formatterString;

@end
NS_ASSUME_NONNULL_END
