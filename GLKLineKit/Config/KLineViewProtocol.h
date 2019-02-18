//
//  KLineViewProtocol.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/4/28.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 对KLineView的配置 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol KLineViewProtocol <NSObject>
@required
/**
 K线图的内边距
 */
- (UIEdgeInsets)insetsOfKlineView;

/**
 边框的内边距
 */
- (UIEdgeInsets)insetsOfBorder;

/**
 是否绘制边框
 */
- (BOOL)isHaveBorder;

/**
 边框宽度
 */
- (CGFloat)borderWidth;

/**
 边框颜色
 */
- (UIColor *)borderColor;

/**
 影线宽度
 */
- (CGFloat)hatchLineWidth;

/**
 实体线最小宽度
 */
- (CGFloat)minEntityLineWidth;

/**
 实体线的默认宽度
 */
- (CGFloat)defaultEntityLineWidth;

/**
 实体线最大宽度
 */
- (CGFloat)maxEntityLineWidth;

/**
 最大的缩放比例
 */
- (CGFloat)maxPinchScale;

/**
 最小的缩放比例
 */
- (CGFloat)minPinchScale;

/**
 K线之间的间隔宽度
 */
- (CGFloat)klineGap;

/**
 上涨的颜色
 */
- (UIColor *)risingColor;

/**
 下跌的颜色
 */
- (UIColor *)fallingColor;

/*
 分时线颜色
 */
- (UIColor *)timeLineColor;

/*
 是否充满,如果传入YES，最小显示K线数量无效
 */
- (BOOL)isFullKline;

/*
 图形上方详细数据的字体大小
 */
- (UIFont *)detailInfoFont;

/**
 最小显示k线数量
 */
- (NSInteger)minShowKlineCount;

/**
 水平分割线的条数
 */
- (NSInteger)horizontalSeparatorCount;

/**
 垂直分割线条数
 */
- (NSInteger)verticalSeparatorCount;

/**
 分割线宽度，默认0.5f
 */
- (CGFloat)separatorWidth;

/**
 ma5 线的颜色
 */
- (UIColor *)ma5Color;

/**
 ma10 线的颜色
 */
- (UIColor *)ma10Color;

/**
 ma30 线的颜色
 */
- (UIColor *)ma30Color;

/**
 Boll线上轨的颜色
 */
- (UIColor *)bollUpColor;

/**
 Boll线中轨的颜色
 */
- (UIColor *)bollMidColor;

/**
 Boll线下轨的颜色
 */
- (UIColor *)bollDownColor;

/**
 MACD中DIF线的颜色
 */
- (UIColor *)macdDIFColor;

/**
 MACD中DEA线的颜色
 */
- (UIColor *)macdDEAColor;

/**
 RSI中RSI1线的颜色
 */
- (UIColor *)rsiRSI_1_color;

/**
 RSI中RSI2线的颜色
 */
- (UIColor *)rsiRSI_2_color;

/**
 RSI中RSI3线的颜色
 */
- (UIColor *)rsiRSI_3_color;

/**
 KDJ中k线的颜色
 */
- (UIColor *)kdj_K_color;

/**
 KDJ中d线的颜色
 */
- (UIColor *)kdj_D_color;

/**
 KDJ中j线的颜色
 */
- (UIColor *)kdj_J_color;

/**
 日期(时分)的最小宽度[hh:mm]
 */
- (CGFloat)dateMinWidthHHmm;

/**
 日期(月/日)的最小宽度[MM/dd]
 */
- (CGFloat)dateMinWidthMMdd;

@end
