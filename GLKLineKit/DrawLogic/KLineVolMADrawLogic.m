//
//  KLineVolMADrawLogic.m
//  KLineDemo
//
//  Created by walker on 2018/5/22.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineVolMADrawLogic.h"
#import "DataCenter.h"

@interface KLineVolMADrawLogic ()

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
 MA5点的集合
 */
@property (strong, nonatomic) NSMutableArray *volMa5PointArray;

/**
 MA10点的集合
 */
@property (strong, nonatomic) NSMutableArray *volMa10PointArray;

/**
 选中的模型
 */
@property (strong, nonatomic) KLineModel *selectedModel;
@end

@implementation KLineVolMADrawLogic

- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType{
    if (self = [super initWithRect:rect drawLogicIdentifier:identifier graphType:graphType]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
    
    NSLog(@"VOLMA data prepare begin");
    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeVolMA]){
        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeVolMA fromIndex:0];
        NSLog(@"VOLMA data prepare finish");
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
    
    [self p_drawIndicatorDetailWithRect:self.logicRect];
    
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
    
    [self.volMa5PointArray removeAllObjects];
    [self.volMa10PointArray removeAllObjects];
    
    // 计算绘图的x值
    CGFloat drawX = - (self.perItemWidth * (visibleRange.x - beginItemIndex));
    
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        // 中心x值
        CGFloat centerX = drawX + (self.perItemWidth / 2.0);
        if (tempModel.volMa5 >= 0) {
            // MA5的点
            CGFloat pointY = self.logicRect.size.height * (1.0f - (tempModel.volMa5 - self.extremeValue.minValue) / diffValue) + self.logicRect.origin.y;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.volMa5PointArray addObject:pointValue];
        }
        
        if (tempModel.volMa10 >= 0) {
            // MA10的点
            CGFloat pointY = self.logicRect.size.height * (1.0f - (tempModel.volMa10 - self.extremeValue.minValue) / diffValue) + self.logicRect.origin.y;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.volMa10PointArray addObject:pointValue];
        }
        
        drawX += self.perItemWidth;
    }
    
    // ma5
    [self p_drawLineWithPointArray:self.volMa5PointArray atContent:ctx color:[self.config ma5Color].CGColor];
    
    // ma10
    [self p_drawLineWithPointArray:self.volMa10PointArray atContent:ctx color:[self.config ma10Color].CGColor];
    
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
        
        NSInteger index = [[argu objectForKey:KlineViewReticleSelectedModelIndexKey] integerValue];
        if (index < [DataCenter shareCenter].klineModelArray.count) {
            self.selectedModel = [[DataCenter shareCenter].klineModelArray objectAtIndex:index];
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
            
            if (tempModel.volMa5) {
                if (tempModel.volMa5 > maxValue) {
                    maxValue = tempModel.volMa5;
                }
                if(tempModel.volMa5 < minValue) {
                    minValue = tempModel.volMa5;
                }
            }
            
            if (tempModel.volMa10) {
                if (tempModel.volMa10 > maxValue) {
                    maxValue = tempModel.volMa10;
                }
                if(tempModel.volMa10 < minValue) {
                    minValue = tempModel.volMa10;
                }
            }
        }
    }
    
    // 调用传入的block，更新视图的最大最小值
    if(arguments) {
        UpdateExtremeValueBlock block = [arguments objectForKey:updateExtremeValueBlockAtDictionaryKey];
        if (block) {
            block(self.drawLogicIdentifier,self.graphType, minValue, maxValue);
        }
    }
    
    minValue = fmin(minValue, self.extremeValue.minValue);
    maxValue = fmax(maxValue, self.extremeValue.maxValue);
    
    self.extremeValue = GLExtremeValueMake(minValue, maxValue);
}


// 绘制上方的详情视图
- (void)p_drawIndicatorDetailWithRect:(CGRect)rect {
    
    if (self.selectedModel) {
        
        NSString *indicatorName = @"MA(5,10)  ";
        
        NSString *volString = [NSString stringWithFormat:@"VOL:%@ ",[@(self.selectedModel.volume) stringValue]];
        
        NSString *volMa5String = [NSString stringWithFormat:@"ma5:%@ ",[@(self.selectedModel.volMa5) stringValue]];
        
        NSString *volMa10String = [NSString stringWithFormat:@"ma10:%@",[@(self.selectedModel.volMa10) stringValue]];
        
        NSAttributedString *VOLatt = [[NSAttributedString alloc] initWithString:volString attributes:@{NSFontAttributeName:[self.config detailInfoFont],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        NSAttributedString *volMa5att = [[NSAttributedString alloc] initWithString:volMa5String attributes:@{NSFontAttributeName:[self.config detailInfoFont],NSForegroundColorAttributeName:[self.config ma5Color]}];
        
        NSAttributedString *volMa10att = [[NSAttributedString alloc] initWithString:volMa10String attributes:@{NSFontAttributeName:[self.config detailInfoFont],NSForegroundColorAttributeName:[self.config ma10Color]}];
        
        NSMutableAttributedString *mattirbuteStr = [[NSMutableAttributedString alloc] initWithString:indicatorName attributes:@{NSFontAttributeName:[self.config detailInfoFont],NSForegroundColorAttributeName:[self.config ma5Color]}];
        
        if (VOLatt) {
            [mattirbuteStr appendAttributedString:VOLatt];
        }
        
        if (volMa5att) {
            [mattirbuteStr appendAttributedString:volMa5att];
        }
        
        if (volMa10att) {
            [mattirbuteStr appendAttributedString:volMa10att];
        }
        
        [mattirbuteStr drawInRect:CGRectMake(rect.origin.x + 5.0f, rect.origin.y - 20.0f, rect.size.width - 5.0f, 20.0f)];
    }
}


- (NSMutableArray *)volMa5PointArray {
    if (!_volMa5PointArray) {
        _volMa5PointArray = @[].mutableCopy;
    }
    return _volMa5PointArray;
}

- (NSMutableArray *)volMa10PointArray {
    if (!_volMa10PointArray) {
        _volMa10PointArray = @[].mutableCopy;
    }
    return _volMa10PointArray;
}


@end
