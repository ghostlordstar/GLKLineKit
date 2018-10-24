//
//  NSValue+GLExtremeValue.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/**
 最值结构体的包装类目
 */

#import <Foundation/Foundation.h>
#import "GLConstantDefinition.h"
@interface NSValue (GLExtremeValue)

/**
 为GLExtremeValue结构体生成NSValue对象的便捷方法

 @param value 结构体值
 @return 包装后的NSValue对象
 */
+ (instancetype)gl_valuewithGLExtremeValue:(GLExtremeValue)value;

/**
 从NSValue对象中取出GLExtremeValue结构体
 */
@property (readonly) GLExtremeValue gl_extremeValue;
@end
