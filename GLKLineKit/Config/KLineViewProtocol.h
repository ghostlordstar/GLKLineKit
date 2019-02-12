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
 
 @return 内边距
 */
- (UIEdgeInsets)insetsOfKlineView;

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

 @return 缩放比例最大值
 */
- (CGFloat)maxPinchScale;

/**
 最小的缩放比例

 @return 缩放比例的最小值
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

/* 是否充满,如果传入YES，最小显示K线数量无效 */
- (BOOL)isFullKline;

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

@end
