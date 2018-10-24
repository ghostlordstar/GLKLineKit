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
    CGSize textSize = [text boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGFloat originX = rect.origin.x + ((rect.size.width - textSize.width) / 2.0);
    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);
    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(originX, originY, rect.size.width, textSize.height);
    
    // 绘制字体
    [text drawInRect:textRect withAttributes:attributes];
}

/**
 绘制一个垂直居中的文字
 
 @param rect 绘制的区域
 @param text 绘制的文字
 @param attributes 文字的样式 上下间距设置无效
 */
+ (void)gl_drawVerticalCenterTextInRect:(CGRect)rect text:(NSString *)text attributes:(NSDictionary *)attributes {
    
    // 计算字体的大小
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(rect.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
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

/**
 添加分割线
 
 @param ctx 绘图上下文
 @param rect 绘制的区域
 @param lineHeight 分割线高度
 @param color 分割线颜色
 */
+ (void)gl_drawSeparatorLineWithCtx:(CGContextRef)ctx inRect:(CGRect)rect lineHeight:(CGFloat)lineHeight separatorColor:(UIColor *)color {
    
    if (lineHeight <= 0) {
        lineHeight = 0.0f;
    }
    
    UIColor *lineColor = [UIColor whiteColor];
    if(color) {
        lineColor = color;
    }
    
    CGContextSetLineWidth(ctx, lineHeight);
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    CGContextMoveToPoint(ctx, 0.0f, rect.size.height - (lineHeight / 2.0f));
    
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - (lineHeight / 2.0f));
    
    CGContextStrokePath(ctx);
}

/**
 绘制色块
 
 @param ctx 图形上下文
 @param rect 色块区域
 @param color 色块颜色
 */
+ (void)gl_drawBackGroundColorWithCtx:(CGContextRef)ctx rect:(CGRect)rect color:(UIColor *)color {
    
    [color ? : [UIColor whiteColor] setFill];
    CGContextFillRect(ctx, rect);
}

#pragma mark - 绘制文本阵列 ---

/**
 绘制一个文本阵列,如下图
 
 |----------------------------|
 |key1      key2      key3    |
 |value1    value2    value3  |
 |                           -|--> 此间隔为verticalGap
 |key4      key5      key6    |
 |value4    value5    value6  |
 |----------------------------|
 
 @param ctx 上下文
 @param rect 区域
 @param count 列数
 @param verticalGap 垂直距离
 @param keyAttributes 标题的样式
 @param valueAttributes 内容的样式
 @param textArray 文本内容
 */
+ (void)gl_drawTextArrayWithCtx:(CGContextRef)ctx rect:(CGRect)rect listCount:(NSInteger)count verticalGap:(CGFloat)verticalGap keyAttributes:(NSDictionary *)keyAttributes valueAttributes:(NSDictionary *)valueAttributes textArray:(NSArray <NSDictionary *>*)textArray {
    
    if(ctx == NULL) {
        NSAssert(false, @"(+ gl_drawTextArrayWithCtx:rect:verticalGap:keyAttributes:valueAttributes:textArray:) ctx don't be NULL");
        return;
    }
    
    if(CGRectEqualToRect(rect, CGRectZero)) {
        NSAssert(false, @"(+ gl_drawTextArrayWithCtx:rect:verticalGap:keyAttributes:valueAttributes:textArray:) rect don't be CGRectZero");
        return;
    }
    
    if(!textArray || textArray.count <= 0) {
        NSAssert(false, @"(+ gl_drawTextArrayWithCtx:rect:verticalGap:keyAttributes:valueAttributes:textArray:) textArray count is 0");
        return;
    }
    
    CGFloat vGap = verticalGap > 0 ? verticalGap : 10.0f;   // 垂直间隔
    NSInteger listCount = count >= 1 ? count : 3;           // 列数
    CGFloat textWidth = rect.size.width / (CGFloat)listCount;
    UIFont *keyFont = [keyAttributes objectForKey:NSFontAttributeName];
    CGFloat keyHeight = [keyFont pointSize] + SCALE_Length(4.0f);   // 标题的高度
    UIFont *valueFont = [valueAttributes objectForKey:NSFontAttributeName];
    CGFloat valueHeight = [valueFont pointSize] + SCALE_Length(4.0f);   // 内容的高度
    
    for (NSInteger a = 0; a < textArray.count; a ++) {
        NSDictionary *tempDict = [textArray objectAtIndex:a];
        
        NSString *tempKey = [[tempDict allKeys] firstObject];
        NSString *tempValue = [[tempDict allValues] firstObject];
        
        if (tempKey && [tempKey isKindOfClass:[NSString class]]) {
            [self gl_drawVerticalCenterTextInRect:CGRectMake(rect.origin.x + (a % listCount) * textWidth, rect.origin.y + (a / listCount) * (keyHeight + valueHeight + vGap), textWidth, keyHeight) text:tempKey attributes:keyAttributes];
        }
        
        if (tempValue && [tempValue isKindOfClass:[NSString class]]) {
            [self gl_drawVerticalCenterTextInRect:CGRectMake(rect.origin.x + (a % listCount) * textWidth, rect.origin.y + (a / listCount) * (keyHeight + valueHeight + vGap) + keyHeight , textWidth, keyHeight) text:tempValue attributes:valueAttributes];
        }
    }
}

@end
