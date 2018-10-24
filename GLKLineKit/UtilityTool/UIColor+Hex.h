//
//  UIColor+Hex.h
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 十六进制颜色转成UIColor

 @param hexColor 十六进制颜色
 */
+ (UIColor *)colorWithHex:(long)hexColor;

/**
 十六进制颜色转成UIColor
 
 @param hexColor 十六进制颜色
 @param alpha 透明度
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)alpha;

/**
 返回一个随机颜色
 */
+ (UIColor *)randomColor;
@end
