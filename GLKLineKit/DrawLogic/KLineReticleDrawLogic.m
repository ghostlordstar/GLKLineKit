//
//  KLineReticleDrawLogic.m
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/2/23.
//  Copyright © 2019 walker. All rights reserved.
//

#import "KLineReticleDrawLogic.h"
#import "DataCenter.h"

@interface KLineReticleDrawLogic ()

/**
 每个item的宽度
 */
@property (assign, nonatomic) CGFloat perItemWidth;

/**
 K线实体线宽度
 */
@property (assign, nonatomic) CGFloat entityLineWidth;

/**
 触点
 */
@property (assign, nonatomic) CGPoint touchPoint;

@property (assign, nonatomic) CGFloat lineWidth;

@property (strong, nonatomic) KLineModel *selectedModel;

@end

@implementation KLineReticleDrawLogic

- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType{
    if (self = [super initWithRect:rect drawLogicIdentifier:identifier graphType:graphType]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
}

- (void)updateConfig:(NSObject<KLineViewProtocol> *)config {
    [super updateConfig:config];
    
//    self.logicRect = UIEdgeInsetsInsetRect(self.logicRect, [self.config insetsOfBorder]);
    UIEdgeInsets insets = [self.config insetsOfKlineView];
    self.logicRect = CGRectMake(insets.left, insets.top, self.logicRect.size.width - insets.left - insets.right, self.logicRect.size.height - insets.top);
}

/**
 根据上下文和绘制区域绘制图形
 */
- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments {
    NSLog(@"drawRect [%s] :%@",__FILE__,NSStringFromCGRect(rect));
    
    // 开始和结束的K线下标
    NSInteger beginItemIndex = floor(visibleRange.x);
    NSInteger endItemIndex = ceil(visibleRange.y);
    if (beginItemIndex < 0) {
        beginItemIndex = 0;
    }
    
    // 实体线宽度
    self.entityLineWidth = [self.config defaultEntityLineWidth] *scale;
    
    if (self.entityLineWidth > [self.config maxEntityLineWidth]) {
        self.entityLineWidth = [self.config maxEntityLineWidth];
    }else if(self.entityLineWidth < [self.config minEntityLineWidth]) {
        self.entityLineWidth = [self.config minEntityLineWidth];
    }
    
    // 每个元素的宽度
    self.perItemWidth = (scale * self.config.klineGap) + self.entityLineWidth;
    
    // 修正最后一个元素下标，防止数组越界
    if (endItemIndex >= [DataCenter shareCenter].klineModelArray.count) {
        endItemIndex = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    NSArray *points = [arguments objectForKey:KlineViewTouchPointValueArrayKey];
    
    NSInteger selectedIndex = [[arguments objectForKey:KlineViewReticleSelectedModelIndexKey] integerValue];
//    NSNumber *selected = [arguments objectForKey:KlineViewReticleSelectedModelIndexKey];
    
    if (selectedIndex < [DataCenter shareCenter].klineModelArray.count) {
        self.selectedModel = [[DataCenter shareCenter].klineModelArray objectAtIndex:selectedIndex];
    }
    NSValue *pointValue = [points firstObject];
    
    if (!pointValue || !self.selectedModel) {
        
        return;
        
    }
    
    CGPoint touchPoint = [pointValue CGPointValue];
    
    
    // 横轴 -------
    CGPoint y_beginPoint = CGPointMake(0, touchPoint.y);
    CGPoint y_endPoint = CGPointMake(self.logicRect.size.width, touchPoint.y);
    
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, self.lineWidth);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, [self.config reticle_color].CGColor);
    
    
    CGContextMoveToPoint(ctx, y_beginPoint.x, y_beginPoint.y);
    
    CGContextAddLineToPoint(ctx, y_endPoint.x, y_endPoint.y);
    
    CGContextStrokePath(ctx);

    // 纵轴 --------
    CGFloat tempx = (selectedIndex - visibleRange.x + 0.5) * self.perItemWidth;
    
    CGPoint x_beginPoint = CGPointMake(tempx, self.logicRect.origin.y - 10.0f);
    
    CGPoint x_endPoint = CGPointMake(tempx,self.logicRect.size.height + self.logicRect.origin.y);
    
    CGContextMoveToPoint(ctx, x_beginPoint.x, x_beginPoint.y);
    
    CGContextAddLineToPoint(ctx, x_endPoint.x, x_endPoint.y);
    
    CGContextStrokePath(ctx);
    
    NSLog(@"567890 : %ld",selectedIndex);
}

@end
