//
//  NSObject+DrawText.m
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "NSObject+DrawText.h"

@implementation NSObject (DrawText)
/**
 绘制一个左右和垂直居中的文字
 
 @param rect 绘制的区域
 @param text 绘制的文字
 @param attributes 文字的样式
 */
+ (void)gl_drawTextInRect:(CGRect)rect text:(NSString *)text attributes:(NSDictionary *)attributes {
    
    // 计算字体的大小
    CGSize textSize = [text sizeWithAttributes:attributes];
    
    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);
    
    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(rect.origin.x, originY, rect.size.width, textSize.height);
    
    // 绘制字体
    [text drawInRect:textRect withAttributes:attributes];
}

/**
 绘制背景框
 
 @param bgRect 背景框的尺寸
 @param ctx 绘图上下文
 @param boderColor 边框颜色
 @param boderWidth 边框宽度
 @param fillColor 填充颜色
 */
+ (void)gl_drawTextBackGroundInRect:(CGRect)bgRect content:(CGContextRef)ctx boderColor:(UIColor *)boderColor boderWidth:(CGFloat)boderWidth fillColor:(UIColor *)fillColor {
    // 设置线宽
    CGContextSetLineWidth(ctx, boderWidth);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, boderColor.CGColor);
    
    // 添加矩形
    CGContextAddRect(ctx, bgRect);
    // 添加填充颜色
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    // 绘制填充
    CGContextFillPath(ctx);
    
    // 添加矩形
    CGContextAddRect(ctx, bgRect);
    // 绘制边框
    CGContextStrokePath(ctx);
}

@end
