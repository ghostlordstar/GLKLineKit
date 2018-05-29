//
//  NSValue+GLExtremeValue.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "NSValue+GLExtremeValue.h"

@implementation NSValue (GLExtremeValue)

/**
 为GLExtremeValue结构体生成NSValue对象的便捷方法
 
 @param value 结构体值
 @return 包装后的NSValue对象
 */
+ (instancetype)gl_valuewithGLExtremeValue:(GLExtremeValue)value {
    // 返回包装后的NSValue 对象
    return [NSValue value:&value withObjCType:@encode(GLExtremeValue)];
}

/**
 从NSValue对象中取出GLExtremeValue结构体
 */
- (GLExtremeValue)gl_extremeValue {
    // 初始化结构体
    GLExtremeValue extremeValue;
    // 给结构体赋值
    if (@available(iOS 11.0, *)) {
        // iOS 11以后推荐用此方法
        [self getValue:&extremeValue size:sizeof(GLExtremeValue)];
    } else {
        // 此方法在将来可能会被废弃
        [self getValue:&extremeValue];
    }
    return extremeValue;
}

@end
