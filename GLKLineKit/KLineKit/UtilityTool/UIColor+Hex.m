//
//  UIColor+Hex.m
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

/**
 十六进制颜色转成UIColor
 
 @param hexColor 十六进制颜色
 */
+ (UIColor *)colorWithHex:(long)hexColor {
    return [UIColor colorWithHex:hexColor alpha:1.0f];
}

/**
 十六进制颜色转成UIColor
 
 @param hexColor 十六进制颜色
 @param alpha 透明度
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)alpha {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/**
 返回一个随机颜色
 */
+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0f blue:arc4random_uniform(255)/255.0f alpha:1];
}

@end
