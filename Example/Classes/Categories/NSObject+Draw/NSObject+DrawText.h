//
//  NSObject+DrawText.h
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TextDetailModel;

@interface NSObject (DrawText)

/**
 绘制一个左右和垂直居中的文字
 
 @param rect 绘制的区域
 @param text 绘制的文字
 @param attributes 文字的样式 左右对齐方式无效
 */
+ (void)gl_drawTextInRect:(CGRect)rect text:(NSString *)text attributes:(NSDictionary *)attributes;

/**
 绘制一个垂直居中的文字

 @param rect 绘制的区域
 @param text 绘制的文字
 @param attributes 文字的样式 上下间距设置无效
 */
+ (void)gl_drawVerticalCenterTextInRect:(CGRect)rect text:(NSString *)text attributes:(NSDictionary *)attributes;


/**
 绘制背景框
 
 @param bgRect 背景框的尺寸
 @param ctx 绘图上下文
 @param boderColor 边框颜色
 @param boderWidth 边框宽度
 @param fillColor 填充颜色
 */
+ (void)gl_drawTextBackGroundInRect:(CGRect)bgRect content:(CGContextRef)ctx boderColor:(UIColor *)boderColor boderWidth:(CGFloat)boderWidth fillColor:(UIColor *)fillColor;

/**
 添加底部分割线
 
 @param ctx 绘图上下文
 @param rect 绘制的区域
 @param lineHeight 分割线高度
 @param color 分割线颜色
 */
+ (void)gl_drawSeparatorLineWithCtx:(CGContextRef)ctx inRect:(CGRect)rect lineHeight:(CGFloat)lineHeight separatorColor:(UIColor *)color;

/**
 绘制色块
 
 @param ctx 图形上下文
 @param rect 色块区域
 @param color 色块颜色
 */
+ (void)gl_drawBackGroundColorWithCtx:(CGContextRef)ctx rect:(CGRect)rect color:(UIColor *)color;

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
+ (void)gl_drawTextArrayWithCtx:(CGContextRef)ctx rect:(CGRect)rect listCount:(NSInteger)count verticalGap:(CGFloat)verticalGap keyAttributes:(NSDictionary *)keyAttributes valueAttributes:(NSDictionary *)valueAttributes textArray:(NSArray <NSDictionary *>*)textArray;

@end
