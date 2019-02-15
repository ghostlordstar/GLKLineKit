//
//  KLineBaseConfig.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/4/28.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineBaseConfig.h"
#import "UIColor+Hex.h"
@implementation KLineBaseConfig

/**
 K线图的内边距
 
 @return 内边距
 */
- (UIEdgeInsets)insetsOfKlineView {
    
    CGFloat borderWidth = [self borderWidth];
    
    return UIEdgeInsetsMake(borderWidth + 20.0f, borderWidth, borderWidth + 20.0f, borderWidth);
}

/**
 边框的内边距
 
 @return 内边距
 */
- (UIEdgeInsets)insetsOfBorder {
    
    CGFloat borderWidth = [self borderWidth];
    
    return UIEdgeInsetsMake(borderWidth + 10.0f, borderWidth, borderWidth + 10.0f, borderWidth);
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
    
    if ([self isHaveBorder]) {
        return 0.5f;
    }else {
        return 0.0f;
    }
}

/**
 边框颜色
 */
- (UIColor *)borderColor {
    
    return [UIColor colorWithHex:0x999999];
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

    return [UIColor colorWithHex:0x4FB336]; // 绿色
}

/**
 下跌的颜色
 */
- (UIColor *)fallingColor {

    return [UIColor colorWithHex:0xE70F56]; // 红色
}

/*
 分时线颜色
 */
- (UIColor *)timeLineColor {
    return kCustomBlueColor;
}

/* 是否充满,如果传入YES，最小显示K线数量无效 */
- (BOOL)isFullKline {
    return YES;
}

/* 图形上方详细数据的字体大小 */
- (UIFont *)detailInfoFont {
    
    return [UIFont systemFontOfSize:10.0f];
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
 分割线宽度，默认0.5f
 */
- (CGFloat)separatorWidth {
    
    return 0.5;
}

/**
 ma5 线的颜色
 */
- (UIColor *)ma5Color {
    
    return [UIColor colorWithHex:0x999999];
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

/**
 Boll线上轨的颜色
 */
- (UIColor *)bollUpColor {
    return [UIColor colorWithHex:0x999999];
}

/**
 Boll线中轨的颜色
 */
- (UIColor *)bollMidColor {
     return [UIColor colorWithHex:0x195494];
}

/**
 Boll线下轨的颜色
 */
- (UIColor *)bollDownColor {
    return [UIColor colorWithHex:0xc830ce];
}

/**
 MACD中DIF线的颜色
 */
- (UIColor *)macdDIFColor {
    
    return kCustomYellowColor;
}

/**
 MACD中DEA线的颜色
 */
- (UIColor *)macdDEAColor {
    
    return kCustomGreenColor;
}

/**
 RSI中RSI1线的颜色
 */
- (UIColor *)rsiRSI_1_color {
    
    return kCustomYellowColor;
}

/**
 RSI中RSI2线的颜色
 */
- (UIColor *)rsiRSI_2_color {
    return kCustomGreenColor;
}

/**
 RSI中RSI3线的颜色
 */
- (UIColor *)rsiRSI_3_color {
    return kCustomPurpleColor;
}

/**
 KDJ中k线的颜色
 */
- (UIColor *)kdj_K_color {
     return kCustomYellowColor;
}

/**
 KDJ中d线的颜色
 */
- (UIColor *)kdj_D_color {
    return kCustomGreenColor;
}

/**
 KDJ中j线的颜色
 */
- (UIColor *)kdj_J_color {
    return kCustomPurpleColor;
}

/*
 日期之间最小间隔
 */
- (CGFloat)dateMinGap {
    return 20.0f;
}

@end
