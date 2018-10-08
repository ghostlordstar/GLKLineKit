//
//  KLineDataLogic.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/9.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* K线视图手势事件变化的逻辑处理 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KLineDataLogicProtocol <NSObject>
@required

#pragma mark - K线绘图相关 ---
/**
 可见区域已经改变

 @param visibleRange 改变后的可见区域
 @param scale 当前的scale
 */
- (void)visibleRangeDidChanged:(CGPoint)visibleRange scale:(CGFloat)scale;

#pragma mark - 十字线相关 ----

/**
 十字线的显示状态
 
 @param isShow 是否显示
 */
- (void)reticleIsShow:(BOOL)isShow;

@optional

/**
 KLineView 上触点移动的回调方法(十字线移动)
 
 @param view 触点起始的View
 @param point point 点击的点
 @param index index 当前触点所在item的下标
 */
- (void)klineView:(KLineView *)view didMoveToPoint:(CGPoint)point selectedItemIndex:(NSInteger)index;

@end

@interface KLineDataLogic : NSObject

/**
 添加代理
 
 @param delegate 遵循<KlineDataLogicProtocol>协议的代理
 支持多代理模式，但是要记得移除，否则会造成多次调用
 */
- (void)addDelegate:(id<KLineDataLogicProtocol>_Nonnull)delegate;

/**
 移除代理
 
 @param delegate 遵循<KlineDataLogicProtocol>协议的代理
 */
- (void)removeDelegate:(id<KLineDataLogicProtocol>_Nonnull)delegate;

/**
 初始化方法
 备注：初始化时要传入初始化时的visibleRange,否则计算有错误
 @param visibleRange 当前的visibleRange
 @param perItemWidth 默认的元素宽度
 */
- (instancetype)initWithVisibleRange:(CGPoint)visibleRange perItemWidth:(CGFloat)perItemWidth NS_DESIGNATED_INITIALIZER;

/**
 当前显示的范围
 */
@property (readonly, assign, nonatomic) CGPoint visibleRange;

/** K线是否是充满模式 */
@property (assign, nonatomic) BOOL isFull;

/**
 最小显示K线数量
 */
@property (assign, nonatomic) NSInteger minKlineCount;

/**
 因为一些其他原因更新当前显示的区域，比如视图的frame变化
 */
- (void)updateVisibleRange:(CGPoint)visibleRange;

/**
 根据偏移量计算当前可显示的区域

 算法：  offsetItem = offsetX / perItemWidth;
        newVisibleRange = {x + offsetItem , y + offsetItem};
 
 @param offsetX 偏移量
 @param perItemWidth 每个元素的宽度
 */
- (void)updateVisibleRangeWithOffsetX:(CGFloat)offsetX perItemWidth:(CGFloat)perItemWidth;

/**
 根据缩放中心点位置计算当前可显示的区域
 
 算法：  itemCount = ((y - x) * perItemWidth1 / perItemWidth2);
        new_x = (itemCount * centerPercent) + x;
        new_y = new_x + itemCount;
 
 @param percent 缩放中心点在k线图的位置 (0.0f ~ 1.0f)
 @param perItemWidth 每个元素的宽度
 @param scale 当前缩放比例
 */
- (void)updateVisibleRangeWithZoomCenterPercent:(CGFloat)percent perItemWidth:(CGFloat)perItemWidth scale:(CGFloat)scale;

#pragma mark - 十字线相关 ----

/**
 KLineView的点击手势 (将要出现十字线)

 @param view KLineView
 @param point 触点的位置
 @param perItemWidth 当前的Item宽度
 */
- (void)beginTapKLineView:(KLineView *)view touchPoint:(CGPoint)point perItemWidth:(CGFloat)perItemWidth;

/**
 手指在KLineView上移动 (十字线将要移动)

 @param view KLineView
 @param point 触点的位置
 @param perItemWidth 当前的item宽度
 */
- (void)moveTouchAtKLineView:(KLineView *)view touchPoint:(CGPoint)point perItemWidth:(CGFloat)perItemWidth;

/**
 取消当前的显示状态 (十字线将要隐藏)

 @param view KLineView
 @param point 触点的位置
 @param perItemWidth 当前的Item宽度
 */
- (void)removeTouchAtKLineView:(KLineView *)view touchPoint:(CGPoint)point perItemWidth:(CGFloat)perItemWidth;
#pragma mark - 禁用方法 --

- (instancetype)init NS_UNAVAILABLE;
@end
