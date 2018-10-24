//
//  NSNumber+StringFormatter.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/18.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 对数字的格式化处理类目 */

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (StringFormatter)

/**
 根据传入的小数位数返回相应的字符串

 @param limit 小数位数限制,如果传入的值 < 0,默认小数位数为8
 @return 指定小数位数的字符串
 */
- (NSString *_Nullable)gl_numberToStringWithDecimalsLimit:(NSInteger)limit;

@end
NS_ASSUME_NONNULL_END
