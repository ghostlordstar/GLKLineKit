//
//  KLineDataLogic.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/9.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineDataLogic.h"
#import "DataCenter.h"
@interface KLineDataLogic()

/**
 当前显示的范围
 */
@property (readwrite, assign, nonatomic) CGPoint visibleRange;

/**
 当前的每个item的宽度
 */
@property (assign, nonatomic) CGFloat currentPerItemWidth;

/**
 代理集合
 */
@property (strong, nonatomic) NSPointerArray *delegateContainer;

/**
 缩放比例
 */
@property (assign, nonatomic) CGFloat currentScale;

@end

@implementation KLineDataLogic

#pragma mark - 代理相关 ----- begin ---

/**
 添加代理
 
 @param delegate 遵循<DataCenterProtocol>协议的代理
 支持多代理模式，但是要记得移除，否则会造成多次调用
 */
- (void)addDelegate:(id<DataCenterProtocol>)delegate {
    if(delegate) {
        for (id tempDelegate in self.delegateContainer) {
            if ([tempDelegate isEqual:delegate]) {
                // 已经有了这个代理直接return
                return;
            }
        }
        // 将代理添加到弱引用容器中
        [self.delegateContainer addPointer:(__bridge void * _Nullable)(delegate)];
    }
    
    // 自动检测并移除失效的代理
    [self.delegateContainer compact];
}

/**
 移除代理
 
 @param delegate 遵循<DataCenterProtocol>协议的代理
 */
- (void)removeDelegate:(id<DataCenterProtocol>)delegate {
    
    if (delegate) {
        for (int a = 0 ; a < self.delegateContainer.count ; a ++) {
            
            id tempDelegate = [self.delegateContainer pointerAtIndex:a];
            
            if (tempDelegate && [tempDelegate isEqual:delegate]) {
                [self.delegateContainer removePointerAtIndex:a];
                break;
            }
        }
    }
    // 自动检测并移除失效的代理
    [self.delegateContainer compact];
}


/**
 代理弱引用容器的懒加载
 */
- (NSPointerArray *)delegateContainer {
    
    if(!_delegateContainer) {
        _delegateContainer = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegateContainer;
}
#pragma mark - 代理相关 ----- end ---

/**
 初始化方法
 备注：初始化时要传入初始化时的visibleRange,否则计算有错误
 @param visibleRange 当前的visibleRange
 @param perItemWidth 默认的元素宽度
 */
- (instancetype)initWithVisibleRange:(CGPoint)visibleRange perItemWidth:(CGFloat)perItemWidth {
    
    if(self = [super init]) {
        self.visibleRange = visibleRange;
        self.currentPerItemWidth = perItemWidth;
        self.currentScale = 1.0f;
    }
    return self;
}

/**
 因为一些其他原因更新当前显示的区域，比如视图的frame变化
 */
- (void)updateVisibleRange:(CGPoint)visibleRange {
    
    self.visibleRange = visibleRange;
}

/**
 根据偏移量计算当前可显示的区域
 
 算法：  offsetItem = offsetX / perItemWidth;
 newVisibleRange = {x + offsetItem , y + offsetItem};
 
 @param offsetX 偏移量
 @param perItemWidth 每个元素的宽度
 */
- (void)updateVisibleRangeWithOffsetX:(CGFloat)offsetX perItemWidth:(CGFloat)perItemWidth {
    
    
    if (fabs(offsetX) && perItemWidth > 0) {
        // 保存每个item的宽度
        self.currentPerItemWidth = perItemWidth;
        // 偏移的item数量
        CGFloat offsetItem = offsetX / self.currentPerItemWidth;
        // 计算新的可见范围
        CGPoint newRange = CGPointMake(self.visibleRange.x - offsetItem, self.visibleRange.y - offsetItem);
        
        // 修正并更新显示区域
        [self p_fixAndUpdateVisibleRange:newRange];
        
        for (NSObject <KLineDataLogicProtocol>*tempDelegate in self.delegateContainer) {
            
            if (tempDelegate && [tempDelegate respondsToSelector:@selector(visibleRangeDidChanged:scale:)]) {
                [tempDelegate visibleRangeDidChanged:self.visibleRange scale:self.currentScale];
            }
        }
    }
}

/**
 根据缩放中心点位置计算当前可显示的区域
 
 算法：  itemCount = ((y - x) * perItemWidth1 / perItemWidth2);
 new_x = (itemCount * centerPercent) + x;
 new_y = new_x + itemCount;
 
 @param percent 缩放中心点在k线图的位置 (0.0f ~ 1.0f)
 @param perItemWidth 每个元素的宽度
 @param scale 当前缩放比例
 */
- (void)updateVisibleRangeWithZoomCenterPercent:(CGFloat)percent perItemWidth:(CGFloat)perItemWidth scale:(CGFloat)scale {
    
    self.currentScale = scale;
    
    if (!(perItemWidth > 0 && perItemWidth != self.currentPerItemWidth)) {
        // perItemWidth 错误 或者和之前的相等就不用计算
        return ;
    }
    
    // 修正缩放中心点位置错误
    if(percent >= 1.0) {
        percent = 1.0f;
    }else if(percent <= 0) {
        percent = 0.0f;
    }
    
    // 缩放后的比例
    CGFloat tempScale = self.currentPerItemWidth / perItemWidth;
    
    // 计算缩放后的元素个数
    CGFloat itemCount = (self.visibleRange.y - self.visibleRange.x) * tempScale;
    
    // 计算缩放后显示的区域
    CGFloat new_x = (1 - tempScale) * (self.visibleRange.y - self.visibleRange.x) * percent + self.visibleRange.x;
    CGFloat new_y = new_x + itemCount;
    
    // 更新可见区域
    [self p_fixAndUpdateVisibleRange:CGPointMake(new_x, new_y)];
    // 记录当前的元素宽度
    self.currentPerItemWidth = perItemWidth;
    
    for (NSObject <KLineDataLogicProtocol>*tempDelegate in self.delegateContainer) {
        
        if (tempDelegate && [tempDelegate respondsToSelector:@selector(visibleRangeDidChanged:scale:)]) {
            [tempDelegate visibleRangeDidChanged:self.visibleRange scale:self.currentScale];
        }
    }
}

/**
 修正并更新当前显示区域
 @param newRange 需要更新到的显示区域
 */
- (void)p_fixAndUpdateVisibleRange:(CGPoint)newRange {
    self.visibleRange = newRange;
    CGFloat allCount = [DataCenter shareCenter].klineModelArray.count;
    
    if(!self.isFull) { // 非充满状态
        
        // 修正显示区域
        if (allCount >= self.minKlineCount) {
            if(self.visibleRange.x >= allCount - self.minKlineCount) {
                self.visibleRange = CGPointMake(allCount - self.minKlineCount, (allCount - self.minKlineCount) + (newRange.y - newRange.x));
            }
            
            if(self.visibleRange.x < - self.minKlineCount) {
                self.visibleRange = CGPointMake(- self.minKlineCount, (newRange.y - newRange.x) - self.minKlineCount);
            }
        }else if(allCount > 0 && allCount < self.minKlineCount) {
            if(self.visibleRange.x >= allCount) {
                self.visibleRange = CGPointMake(allCount, allCount + (newRange.y - newRange.x));
            }
            
            if(self.visibleRange.x < allCount) {
                self.visibleRange = CGPointMake(- allCount, (newRange.y - newRange.x) - allCount);
            }
        }else {
            
            self.visibleRange = CGPointMake(0, newRange.y - newRange.x);
        }
    }else { // 充满状态
        
        
        if(allCount >= 0) {
            
            if (allCount > (newRange.y - newRange.x)) {
                
                if (newRange.y >= allCount) {
                    if (newRange.x <= 0) {
                        self.visibleRange = CGPointMake(0, allCount - (newRange.y - newRange.x));
                    }else {
                        self.visibleRange = CGPointMake(allCount - (newRange.y - newRange.x), allCount);
                    }
                }else {
                    if (newRange.x <= 0) {
                        self.visibleRange = CGPointMake(0, newRange.y - newRange.x);
                    }else {
                        self.visibleRange = CGPointMake(newRange.x, newRange.y);
                    }
                }
            }else {
                self.visibleRange = CGPointMake(0, allCount);
            }
            
        }else {
            self.visibleRange = CGPointMake(0, 0);
        }
    }
}

  
/**
 最小显示K线根数

 默认为1
 */
- (NSInteger)minKlineCount {
    if (_minKlineCount <= 0) {
        _minKlineCount = 1;
    }
    return _minKlineCount;
}

#pragma mark - 十字线相关 ---

/**
 KLineView的点击手势 (将要出现十字线)
 */
- (void)beginTapKLineView:(KLineView *)view touchPoint:(CGPoint)point perItemWidth:(CGFloat)perItemWidth {
    
    NSInteger  index = 0;
    
    index = ceil(self.visibleRange.x + (point.x / perItemWidth));
    if(index > ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }else if(index < 0) {
        index = 0;
    }
    
    NSLog(@"beigin point = %@",NSStringFromCGPoint(point));

    
    for (NSObject <KLineDataLogicProtocol>*tempDelegate in self.delegateContainer) {
        
        if (tempDelegate && [tempDelegate respondsToSelector:@selector(klineView:didMoveToPoint:selectedItemIndex:)]) {
            [tempDelegate klineView:view didMoveToPoint:point selectedItemIndex:index];
        }
        
        if (tempDelegate && [tempDelegate respondsToSelector:@selector(reticleIsShow:)]) {
            [tempDelegate reticleIsShow:YES];
        }
    }
}

/**
 手指在KLineView上移动 (十字线将要移动)
 */
- (void)moveTouchAtKLineView:(KLineView *)view touchPoint:(CGPoint)point perItemWidth:(CGFloat)perItemWidth {
    NSInteger  index = 0;
    
    index = ceil(self.visibleRange.x + (point.x / perItemWidth));
    if(index > ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }else if(index < 0) {
        index = 0;
    }
    
    NSLog(@"move point = %@",NSStringFromCGPoint(point));
    for (NSObject <KLineDataLogicProtocol>*tempDelegate in self.delegateContainer) {
        
        if (tempDelegate && [tempDelegate respondsToSelector:@selector(klineView:didMoveToPoint:selectedItemIndex:)]) {
            [tempDelegate klineView:view didMoveToPoint:point selectedItemIndex:index];
        }
    }
}

/**
 取消当前的显示状态 (十字线将要隐藏)
 */
- (void)removeTouchAtKLineView:(KLineView *)view touchPoint:(CGPoint)point perItemWidth:(CGFloat)perItemWidth {
    NSInteger  index = 0;
    
    
    index = ceil(self.visibleRange.x + (point.x / perItemWidth));
    if(index > ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }else if(index < 0) {
        index = 0;
    }
    
    NSLog(@"end point = %@",NSStringFromCGPoint(point));

    for (NSObject <KLineDataLogicProtocol>*tempDelegate in self.delegateContainer) {
        
        if (tempDelegate && [tempDelegate respondsToSelector:@selector(klineView:didMoveToPoint:selectedItemIndex:)]) {
            [tempDelegate klineView:view didMoveToPoint:point selectedItemIndex:index];
        }
        
        if (tempDelegate && [tempDelegate respondsToSelector:@selector(reticleIsShow:)]) {
            [tempDelegate reticleIsShow:NO];
        }
    }
}


@end
