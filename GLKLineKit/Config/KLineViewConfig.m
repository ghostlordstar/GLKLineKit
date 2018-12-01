//
//  KLineViewConfig.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/4/28.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineViewConfig.h"
#import "UIColor+Hex.h"
@implementation KLineViewConfig

/**
 K线图的内边距
 
 @return 内边距
 */
- (UIEdgeInsets)insetsOfKlineView {
    
    CGFloat defaultBorderWidth = [self borderWidth] + 1.0f;
    
    return UIEdgeInsetsMake(defaultBorderWidth + 17.0f, defaultBorderWidth, defaultBorderWidth, defaultBorderWidth);
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
    
    return KColorTipText_999;
}

/**
 影线宽度
 */
- (CGFloat)hatchLineWidth {

    return 1.0f;
}

/**
 实体线最小宽度
 */
- (CGFloat)minEntityLineWidth {
    
    return [self defaultEntityLineWidth] * [self minPinchScale];
}

/**
 实体线的默认宽度
 */
- (CGFloat)defaultEntityLineWidth {
    return 5.0f;
}

/**
 实体线最大宽度
 */
- (CGFloat)maxEntityLineWidth {
    return [self defaultEntityLineWidth] * [self maxPinchScale];
}


/**
 最大的缩放比例
 
 @return 缩放比例最大值
 */
- (CGFloat)maxPinchScale {
    
    return 4.0;
}

/**
 最小的缩放比例
 
 @return 缩放比例的最小值
 */
- (CGFloat)minPinchScale {
    
    return 0.1;
}

/**
 K线之间的间隔宽度
 */
- (CGFloat)klineGap {
    
    return 2.0f;
}

/**
 上涨的颜色
 */
- (UIColor *)risingColor {

    return KColorLong;
}

/**
 下跌的颜色
 */
- (UIColor *)fallingColor {

    return KColorShort;
}

/* 是否充满,如果传入YES，最小显示K线数量无效 */
- (BOOL)isFullKline {
    return YES;
}

/**
 最小显示k线数量
 */
- (NSInteger)minShowKlineCount {
    
    return 5;
}

/**
 水平分割线的条数
 */
- (NSInteger)horizontalSeparatorCount {
    return 2;
}

/**
 垂直分割线条数
 */
- (NSInteger)verticalSeparatorCount {
    
    return 4;
}

/**
 ma5 线的颜色
 */
- (UIColor *)ma5Color {
    
    return KColorTipText_999;
}

/**
 ma10 线的颜色
 */
- (UIColor *)ma10Color {
    return [UIColor colorWithHex:0x195494];
}

/**
 ma30 线的颜色
 */
- (UIColor *)ma30Color {
    return [UIColor colorWithHex:0xc830ce];
}

@end
