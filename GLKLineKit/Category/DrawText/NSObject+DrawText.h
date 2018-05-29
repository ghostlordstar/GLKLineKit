//
//  NSObject+DrawText.h
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DrawText)
/**
 绘制一个左右和垂直居中的文字
 
 @param rect 绘制的区域
 @param text 绘制的文字
 @param attributes 文字的样式
 */
+ (void)gl_drawTextInRect:(CGRect)rect text:(NSString *)text attributes:(NSDictionary *)attributes;

/**
 绘制背景框
 
 @param bgRect 背景框的尺寸
 @param ctx 绘图上下文
 @param boderColor 边框颜色
 @param boderWidth 边框宽度
 @param fillColor 填充颜色
 */
+ (void)gl_drawTextBackGroundInRect:(CGRect)bgRect content:(CGContextRef)ctx boderColor:(UIColor *)boderColor boderWidth:(CGFloat)boderWidth fillColor:(UIColor *)fillColor;
@end
