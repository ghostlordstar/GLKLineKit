//
//  KLineMACDDrawLogic.m
//  KLineDemo
//
//  Created by walker on 2018/5/22.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineMACDDrawLogic.h"
#import "DataCenter.h"

@interface KLineMACDDrawLogic()

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
 DIF点的集合
 */
@property (strong, nonatomic) NSMutableArray *difPointArray;

/**
 dea点的集合
 */
@property (strong, nonatomic) NSMutableArray *deaPointArray;

/**
 选中的模型
 */
@property (strong, nonatomic) KLineModel *selectedModel;
@end

@implementation KLineMACDDrawLogic

- (instancetype)initWithDrawLogicIdentifier:(NSString *)identifier {
    if (self = [super initWithDrawLogicIdentifier:identifier]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
    self.extremeValue = GLExtremeValueMake(MAXFLOAT, - MAXFLOAT);
    
    NSLog(@"MA data prepare begin");
    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeMACD]){
        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeMACD fromIndex:0];
        NSLog(@"MA data prepare finish");
    }
    
}

/**
 根据上下文和绘制区域绘制图形
 */
- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments {
    
    if ([DataCenter shareCenter].klineModelArray.count <= 0) {
        return;
    }
    
    [self p_drawIndicatorDetailWithRect:rect];
    
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
    
    [self.difPointArray removeAllObjects];
    [self.deaPointArray removeAllObjects];
    
    // 计算绘图的x值
    CGFloat drawX = - (self.perItemWidth * (visibleRange.x - beginItemIndex));
    
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        // 中心x值
        CGFloat centerX = drawX + (self.perItemWidth / 2.0);
        
        // DIF的点
        CGFloat difPointY = rect.size.height * (1.0f - (tempModel.dif - self.extremeValue.minValue) / diffValue) + rect.origin.y;
        NSValue *difPointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, difPointY)];
        [self.difPointArray addObject:difPointValue];
        
        // DEA的点
        CGFloat deaPointY = rect.size.height * (1.0f - (tempModel.dea - self.extremeValue.minValue) / diffValue) + rect.origin.y;
        NSValue *deaPointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, deaPointY)];
        [self.deaPointArray addObject:deaPointValue];
        
        // MACD柱线
        CGFloat macdStartPointY = rect.size.height * (1.0f - (0.0f - self.extremeValue.minValue) / diffValue) + rect.origin.y;
        CGFloat macdEndPointY = rect.size.height * (1.0f - (tempModel.macd - self.extremeValue.minValue) / diffValue) + rect.origin.y;
        CGColorRef color = [self.config risingColor].CGColor;
        if (macdStartPointY <= macdEndPointY) {
            // 朝下
            color = [self.config fallingColor].CGColor;
        }
        
        [self p_drawLineWithContent:ctx startPoint:CGPointMake(centerX, macdStartPointY) endPoint:CGPointMake(centerX, macdEndPointY) color:color];
        
        drawX += self.perItemWidth;
    }
    
    // dif
    [self p_drawLineWithPointArray:self.difPointArray atContent:ctx color:[self.config ma5Color].CGColor];
    
    // dea
    [self p_drawLineWithPointArray:self.deaPointArray atContent:ctx color:[self.config ma10Color].CGColor];
    
    
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
 绘制线段

 @param startPoint 开始的点
 @param endPoint 结束的点
 @param color 线段的颜色
 */
- (void)p_drawLineWithContent:(CGContextRef)ctx startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(CGColorRef)color  {
    
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, self.entityLineWidth);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, color);
    // 起点
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    // 终点
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    // 绘制
    CGContextStrokePath(ctx);

}


/**
 根据传入的参数更新最大最小值
 
 @param argu 传入的参数
 */
- (void)p_updateExtremeValueWithArguments:(NSDictionary *)argu {
    
    if(argu && [argu isKindOfClass:[NSDictionary class]]) {
        
        NSValue *tempExtremeValue = [argu objectForKey:KlineViewToKlineBGDrawLogicExtremeValueKey];
        GLExtremeValue value = [tempExtremeValue gl_extremeValue];
        self.extremeValue = value;
        self.selectedModel = [argu objectForKey:KlineViewReticleSelectedModelKey];
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
    
    double maxValue = - MAXFLOAT;
    double minValue = MAXFLOAT;
    
    for (NSInteger a = beginIndex; a <= endIndex; a ++) {
        
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        if (tempModel) {
            
            if (tempModel.dif > maxValue) {
                maxValue = tempModel.dif;
            }
            if(tempModel.dif < minValue) {
                minValue = tempModel.dif;
            }

            if (tempModel.dea > maxValue) {
                maxValue = tempModel.dea;
            }
            if(tempModel.dea < minValue) {
                minValue = tempModel.dea;
            }
            
            if(tempModel.macd > maxValue) {
                maxValue = tempModel.macd;
            }
            if(tempModel.macd < minValue) {
                minValue = tempModel.macd;
            }
        }
    }
    
    
    // 调用传入的block，更新视图的最大最小值
    if(arguments) {
        UpdateExtremeValueBlock block = [arguments objectForKey:updateExtremeValueBlockAtDictionaryKey];
        if (block) {
            block(self.drawLogicIdentifier ,minValue,maxValue);
        }
    }
    
    minValue = fmin(minValue, self.extremeValue.minValue);
    maxValue = fmax(maxValue, self.extremeValue.maxValue);
    
    self.extremeValue = GLExtremeValueMake(minValue, maxValue);
}


// 绘制上方的详情视图
- (void)p_drawIndicatorDetailWithRect:(CGRect)rect {
    
    if (self.selectedModel) {
        NSString *indicatorName = @"MACD(12,26,9)  ";
        
        NSString *dif = [NSString stringWithFormat:@"DIF:%@ ",[@(self.selectedModel.dif) gl_numberToStringWithDecimalsLimit:6]];
        
        NSString *dea = [NSString stringWithFormat:@"DEA:%@ ",[@(self.selectedModel.dea) gl_numberToStringWithDecimalsLimit:6]];
        
        NSString *macd = [NSString stringWithFormat:@"MACD:%@",[@(self.selectedModel.macd) gl_numberToStringWithDecimalsLimit:6]];
        
        NSAttributedString *dif_Att = [[NSAttributedString alloc] initWithString:dif attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma5Color]}];
        
        NSAttributedString *dea_Att = [[NSAttributedString alloc] initWithString:dea attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma10Color]}];
        
        NSAttributedString *macd_Att = [[NSAttributedString alloc] initWithString:macd attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma30Color]}];
        
        NSMutableAttributedString *mattirbuteStr = [[NSMutableAttributedString alloc] initWithString:indicatorName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:KColorTipText_999}];
        
        if (dif_Att) {
            [mattirbuteStr appendAttributedString:dif_Att];
        }
        
        if (dea_Att) {
            [mattirbuteStr appendAttributedString:dea_Att];
        }
        
        if (macd_Att) {
            [mattirbuteStr appendAttributedString:macd_Att];
        }
        
        [mattirbuteStr drawInRect:CGRectMake(rect.origin.x + 5.0, 0, rect.size.width - 5.0, 20.0)];
    }
}


- (NSMutableArray *)difPointArray {
    if (!_difPointArray) {
        _difPointArray = @[].mutableCopy;
    }
    return _difPointArray;
}

- (NSMutableArray *)deaPointArray {
    if (!_deaPointArray) {
        _deaPointArray = @[].mutableCopy;
    }
    return _deaPointArray;
}



@end
