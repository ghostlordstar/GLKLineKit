//
//  KLineMADrawLogic.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/19.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineMADrawLogic.h"
#import "DataCenter.h"
#import "NSValue+GLExtremeValue.h"
#import "NSNumber+StringFormatter.h"
@interface KLineMADrawLogic()

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
@property (strong, nonatomic) NSMutableArray *ma5PointArray;

/**
 MA10点的集合
 */
@property (strong, nonatomic) NSMutableArray *ma10PointArray;

/**
 MA30点的集合
 */
@property (strong, nonatomic) NSMutableArray *ma30PointArray;

/**
 ma5 hiden
 */
@property (assign, nonatomic) BOOL isMa5Hiden;

/**
 ma10 hiden
 */
@property (assign, nonatomic) BOOL isMa10Hiden;

/**
 ma30 hiden
 */
@property (assign, nonatomic) BOOL isMa30Hiden;

/**
 选中的模型
 */
@property (strong, nonatomic) KLineModel *selectedModel;

@end

@implementation KLineMADrawLogic
- (instancetype)initWithDrawLogicIdentifier:(NSString *)identifier {
    if (self = [super initWithDrawLogicIdentifier:identifier]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
    self.isMa5Hiden = NO;
    self.isMa10Hiden = NO;
    self.isMa30Hiden = NO;
    
    NSLog(@"MA data prepare begin");
    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeMA]){
        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeMA fromIndex:0];
        NSLog(@"MA data prepare finish");
    }
    
}

/**
 隐藏ma5
 
 @param hide 是否隐藏，传YES隐藏，默认为NO
 */
- (void)setMa5Hiden:(BOOL)hide {
    
    self.isMa5Hiden = hide;
    
}

/**
 隐藏ma10
 
 @param hide 是否隐藏，传YES隐藏，默认为NO
 */
- (void)setMa10Hiden:(BOOL)hide {
    self.isMa10Hiden = hide;
}

/**
 隐藏ma30
 
 @param hide 是否隐藏，传YES隐藏，默认为NO
 */
- (void)setMa30Hiden:(BOOL)hide {
    self.isMa30Hiden = hide;
}


/**
 根据上下文和绘制区域绘制图形
 */
- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments {
    
    if ([DataCenter shareCenter].klineModelArray.count <= 0) {
        return;
    }
    
    // 绘制上方的详情视图
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
    
    [self.ma5PointArray removeAllObjects];
    [self.ma10PointArray removeAllObjects];
    [self.ma30PointArray removeAllObjects];
    
    // 计算绘图的x值
    CGFloat drawX = - (self.perItemWidth * (visibleRange.x - beginItemIndex));
    
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        // 中心x值
        CGFloat centerX = drawX + (self.perItemWidth / 2.0);
        if (tempModel.ma5 > 0) {
            // MA5的点
            CGFloat pointY = rect.size.height * (1.0f - (tempModel.ma5 - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.ma5PointArray addObject:pointValue];
        }
        
        
        if (tempModel.ma10 > 0) {
            // MA10的点
            CGFloat pointY = rect.size.height * (1.0f - (tempModel.ma10 - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.ma10PointArray addObject:pointValue];
        }
        
        if (tempModel.ma30 > 0) {
            
            // MA30的点
            CGFloat pointY = rect.size.height * (1.0f - (tempModel.ma30 - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.ma30PointArray addObject:pointValue];
        }
        
        drawX += self.perItemWidth;
    }
    
    if (!self.isMa5Hiden) {
        // ma5
        [self p_drawLineWithPointArray:self.ma5PointArray atContent:ctx color:[self.config ma5Color].CGColor];
    }
    
    if (!self.isMa10Hiden) {
        // ma10
        [self p_drawLineWithPointArray:self.ma10PointArray atContent:ctx color:[self.config ma10Color].CGColor];
    }
    
    if (!self.isMa30Hiden) {
        // ma30
        [self p_drawLineWithPointArray:self.ma30PointArray atContent:ctx color:[self.config ma30Color].CGColor];
    }
    
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
    
    double maxValue = 0.0;
    double minValue = MAXFLOAT;
    
    for (NSInteger a = beginIndex; a <= endIndex; a ++) {
        
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        if (tempModel) {
            
            
            if (tempModel.ma5 && !self.isMa5Hiden) {
                if (tempModel.ma5 > maxValue) {
                    maxValue = tempModel.ma5;
                }
                if(tempModel.ma5 < minValue) {
                    minValue = tempModel.ma5;
                }
            }
            
            if (tempModel.ma10 && !self.isMa10Hiden) {
                if (tempModel.ma10 > maxValue) {
                    maxValue = tempModel.ma10;
                }
                if(tempModel.ma10 < minValue) {
                    minValue = tempModel.ma10;
                }
            }
            
            if (tempModel.ma30 && !self.isMa30Hiden) {
                if (tempModel.ma30 > maxValue) {
                    maxValue = tempModel.ma30;
                }
                if(tempModel.ma30 < minValue) {
                    minValue = tempModel.ma30;
                }
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

        NSString *indicatorName = @"MA(5,10,30)  ";
        
        NSString *ma5String = [NSString stringWithFormat:@"ma5:%@ ",[@(self.selectedModel.ma5) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit]];
        NSString *ma10String = [NSString stringWithFormat:@"ma10:%@ ",[@(self.selectedModel.ma10) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit]];
        NSString *ma30String = [NSString stringWithFormat:@"ma30:%@",[@(self.selectedModel.ma30) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit]];
        
        NSAttributedString *ma5att = [[NSAttributedString alloc] initWithString:ma5String attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma5Color]}];
        
        NSAttributedString *ma10att = [[NSAttributedString alloc] initWithString:ma10String attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma10Color]}];
        
        NSAttributedString *ma30att = [[NSAttributedString alloc] initWithString:ma30String attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma30Color]}];
        
        NSMutableAttributedString *mattirbuteStr = [[NSMutableAttributedString alloc] initWithString:indicatorName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma30Color]}];
        
        if (!self.isMa5Hiden) {
            [mattirbuteStr appendAttributedString:ma5att];
        }
        
        if (!self.isMa10Hiden) {
            [mattirbuteStr appendAttributedString:ma10att];
        }
        
        if (!self.isMa30Hiden) {
            [mattirbuteStr appendAttributedString:ma30att];
        }
        
        [mattirbuteStr drawInRect:CGRectMake(rect.origin.x + 5.0, 0, rect.size.width - 5.0, 20.0)];
    }
}


- (NSMutableArray *)ma5PointArray {
    if (!_ma5PointArray) {
        _ma5PointArray = @[].mutableCopy;
    }
    return _ma5PointArray;
}

- (NSMutableArray *)ma10PointArray {
    if (!_ma10PointArray) {
        _ma10PointArray = @[].mutableCopy;
    }
    return _ma10PointArray;
}

- (NSMutableArray *)ma30PointArray {
    if (!_ma30PointArray) {
        _ma30PointArray = @[].mutableCopy;
    }
    return _ma30PointArray;
}

@end
