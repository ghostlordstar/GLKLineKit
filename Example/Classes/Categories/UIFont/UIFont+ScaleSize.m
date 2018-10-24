//
//  UIFont+ScaleSize.m
//  kkcoin
//
//  Created by kk_ghostlord on 2018/4/11.
//  Copyright © 2018年 董. All rights reserved.
//

/**
 适配字体大小
 */

#import "UIFont+ScaleSize.h"

@implementation UIFont (ScaleSize)

/**
 根据设备尺寸适配字体大小
 
 @param size 字体大小
 @return 字体对象
 */
+ (instancetype)kk_systemFontOfSize:(CGFloat)size {
    
    return [UIFont systemFontOfSize:[self kk_scaleFontSize:size]];
}

/**
 根据设备尺寸适配字体大小
 
 @param size 字体大小
 @return 加粗字体对象
 */
+ (instancetype)kk_boldSystemFontOfSize:(CGFloat)size {
    
    return [UIFont boldSystemFontOfSize:[self kk_scaleFontSize:size]];
}


/**
 根据设备计算字体大小

 @param size 原始尺寸大小
 @return 适配后的尺寸大小
 */
+ (CGFloat)kk_scaleFontSize:(CGFloat)size {
    
    if (GL_iPhone_4x) {
        size *= 0.84;
    }
    if (GL_iPhone_5x) {
        size *= 0.84;
    }
    if (GL_iPhone_6x || GL_iPhone_X) {
        size *= 1;
    }
    if (GL_iPhone_plus) {
        size *= 1.104;
    }
    
    return size;
}

@end
