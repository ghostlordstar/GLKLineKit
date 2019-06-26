//
//  KLineTimeDrawLogic.m
//  KLineDemo
//
//  Created by walker on 2018/5/21.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 分时绘图算法 */
#import "KLineTimeDrawLogic.h"
#import "DataCenter.h"

@interface KLineTimeDrawLogic()

/**
 最大值最小值
 */
@property (assign, nonatomic) GLExtremeValue extremeValue;

/**
 每个item的宽度
 */
@property (assign, nonatomic) CGFloat perItemWidth;

/**
 平均线宽度
 */
@property (assign, nonatomic) CGFloat lineWidth;

/**
 K线实体线宽度
 */
@property (assign, nonatomic) CGFloat entityLineWidth;

/**
 timePoint
 */
@property (strong, nonatomic) NSMutableArray *timePointArray;

@end

@implementation KLineTimeDrawLogic

- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType{
    if (self = [super initWithRect:rect drawLogicIdentifier:identifier graphType:graphType]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
    
    NSLog(@"MA data prepare begin");
    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeMA]){
        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeMA fromIndex:0];
        NSLog(@"MA data prepare finish");
    }
}

- (void)updateConfig:(NSObject<KLineViewProtocol> *)config {
    [super updateConfig:config];
    
    self.logicRect = UIEdgeInsetsInsetRect(self.logicRect, [self.config insetsOfKlineView]);
}

/**
 根据上下文和绘制区域绘制图形
 */
- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments {
    NSLog(@"drawRect [%s] :%@",__FILE__,NSStringFromCGRect(rect));

    if (CGRectEqualToRect(self.logicRect, CGRectZero)) {
        self.logicRect = UIEdgeInsetsInsetRect(rect, [self.config insetsOfKlineView]);
    }
    
    if ([DataCenter shareCenter].klineModelArray.count <= 0) {
        return;
    }
    // 根据传入的参数更新最大最小值
    [self p_updateExtremeValueWithArguments:arguments];
    
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
    
    // 更新最大最小值
    [self p_updateMinAndMaxValueWithBeginIndex:beginItemIndex endIndex:endItemIndex arguments:arguments];
    
    // 最大最小值的差值
    double diffValue = (self.extremeValue.maxValue - self.extremeValue.minValue) > 0.0 ? (self.extremeValue.maxValue - self.extremeValue.minValue) : 0.0;
    
    if (diffValue <= 0.0) {
        // 没有最大最小值的区分
        //                NSAssert(diffValue > 0.0, @"最大值和最小值差值不能为0");
        return;
    }
    
    [self.timePointArray removeAllObjects];
    
    // 计算绘图的x值
    CGFloat drawX = - (self.perItemWidth * (visibleRange.x - beginItemIndex));
    
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        // 中心x值
        CGFloat centerX = drawX + (self.perItemWidth / 2.0);
        
            // 分时的点
            CGFloat pointY = self.logicRect.size.height * (1.0f - (tempModel.close - self.extremeValue.minValue) / diffValue) + self.logicRect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
        [self.timePointArray addObject:pointValue];
        
        drawX += self.perItemWidth;
    }
    
    [self p_drawLineWithPointArray:self.timePointArray atContent:ctx color:[self.config timeLineColor].CGColor];
}


/**
 根据传入的点的集合绘制线段
 
 @param pointArray 点的集合
 @param ctx 绘图上下文
 */
- (void)p_drawLineWithPointArray:(NSArray *)pointArray atContent:(CGContextRef)ctx color:(CGColorRef)color {
    
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, self.lineWidth);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, color);
    for (int a = 0; a < pointArray.count; a ++) {
        NSValue *value = pointArray[a];
        CGPoint tempPoint = [value CGPointValue];
        if (a == 0) {
            CGContextMoveToPoint(ctx, tempPoint.x, tempPoint.y);
        }else {
            CGContextAddLineToPoint(ctx, tempPoint.x, tempPoint.y);
        }
    }
    
    CGContextStrokePath(ctx);
}


/**
 根据传入的参数更新最大最小值
 
 @param argu 传入的参数
 */
- (void)p_updateExtremeValueWithArguments:(NSDictionary *)argu {
    
    if(argu && [argu isKindOfClass:[NSDictionary class]]) {
        
        NSArray *extremeArray = [argu objectForKey:KlineViewToKlineDrawLogicExtremeValueArrayKey];
        if (extremeArray && extremeArray.count > 0) {
            NSValue *tempExtremeValue = [extremeArray firstObject];
            self.extremeValue = [tempExtremeValue gl_extremeValue];
        }
    }
}

/**
 获得当前显示区域的最大最小值
 */
- (void)p_updateMinAndMaxValueWithBeginIndex:(NSInteger)beginIndex endIndex:(NSInteger)endIndex arguments:(NSDictionary *)arguments {
    
    if ([DataCenter shareCenter].klineModelArray.count <= 0) {
        return;
    }
    
    if (beginIndex < 0) {
        beginIndex = 0;
    }else if(beginIndex >= [DataCenter shareCenter].klineModelArray.count) {
        beginIndex = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if (endIndex < beginIndex) {
        endIndex = beginIndex;
    }
    
    double maxValue = 0.0;
    double minValue = MAXFLOAT;
    
    for (NSInteger a = beginIndex; a <= endIndex; a ++) {
        
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        if (tempModel) {
            
            if (tempModel) {
                if (tempModel.close > maxValue) {
                    maxValue = tempModel.close;
                }
                
                if (tempModel.close < minValue) {
                    minValue = tempModel.close;
                }
            }
        }
    }
    
    // 调用传入的block，更新视图的最大最小值
    if(arguments) {
        UpdateExtremeValueBlock block = [arguments objectForKey:updateExtremeValueBlockAtDictionaryKey];
        if (block) {
            block(self.drawLogicIdentifier, self.graphType, minValue, maxValue);
        }
    }
    
    minValue = fmin(minValue, self.extremeValue.minValue);
    maxValue = fmax(maxValue, self.extremeValue.maxValue);
    
    self.extremeValue = GLExtremeValueMake(minValue, maxValue);
}

#pragma mark - 懒加载 --

- (NSMutableArray *)timePointArray {
    if (!_timePointArray) {
        _timePointArray = @[].mutableCopy;
    }
    return _timePointArray;
}

@end
