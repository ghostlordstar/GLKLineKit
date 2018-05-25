//
//  KLineVolViewConfig.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "KLineVolViewConfig.h"

@implementation KLineVolViewConfig


/**
 K线图的内边距
 
 @return 内边距
 */
- (UIEdgeInsets)insertOfKlineView {
    
    CGFloat defaultBorderWidth = [self borderWidth] + 1.0f;
    
    return UIEdgeInsetsMake(defaultBorderWidth, defaultBorderWidth, defaultBorderWidth, defaultBorderWidth);
}

/**
 是否绘制边框
 */
- (BOOL)isHaveBorder {
    
    return YES;
}

/**
 边框宽度
 */
- (CGFloat)borderWidth {
    
    return 0.5f;
}

/**
 边框颜色
 */
- (UIColor *)borderColor {
    
    return [UIColor whiteColor];
}


/**
 水平分割线的条数
 */
- (NSInteger)horizontalSeparatorCount {
    return 1;
}

/**
 垂直分割线条数
 */
- (NSInteger)verticalSeparatorCount {
    
    return 4;
}


@end
