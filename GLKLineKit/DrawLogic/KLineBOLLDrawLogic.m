//
//  KLineBOLLDrawLogic.m
//  KLineDemo
//
//  Created by walker on 2018/5/22.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineBOLLDrawLogic.h"
#import "DataCenter.h"
#import "NSNumber+StringFormatter.h"

@interface KLineBOLLDrawLogic ()

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
 MID点的集合
 */
@property (strong, nonatomic) NSMutableArray *midPointArray;

/**
 UP点的集合
 */
@property (strong, nonatomic) NSMutableArray *upPointArray;

/**
 LOW点的集合
 */
@property (strong, nonatomic) NSMutableArray *lowPointArray;

/**
 选中的模型
 */
@property (strong, nonatomic) KLineModel *selectedModel;
@end

@implementation KLineBOLLDrawLogic

- (instancetype)initWithDrawLogicIdentifier:(NSString *)identifier {
    if (self = [super initWithDrawLogicIdentifier:identifier]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
    
    NSLog(@"VOLMA data prepare begin");
    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeBOLL]){
        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeBOLL fromIndex:0];
        NSLog(@"VOLMA data prepare finish");
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
    
    [self.midPointArray removeAllObjects];
    [self.upPointArray removeAllObjects];
    [self.lowPointArray removeAllObjects];
    
    // 计算绘图的x值
    CGFloat drawX = - (self.perItemWidth * (visibleRange.x - beginItemIndex));
    
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        // 中心x值
        CGFloat centerX = drawX + (self.perItemWidth / 2.0);
        if (tempModel.boll_up > 0) {
            // 上轨曲线的点
            CGFloat pointY = rect.size.height * (1.0f - (tempModel.boll_up - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.upPointArray addObject:pointValue];
        }
        
        
        if (tempModel.ma20 > 0) {
            // 中轨曲线的点
            CGFloat pointY = rect.size.height * (1.0f - (tempModel.ma20 - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.midPointArray addObject:pointValue];
        }
        
        if (tempModel.boll_low > 0) {
            // 中轨曲线的点
            CGFloat pointY = rect.size.height * (1.0f - (tempModel.boll_low - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
            NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, pointY)];
            
            [self.lowPointArray addObject:pointValue];
        }
        
        
        drawX += self.perItemWidth;
    }
    
    // up
    [self p_drawLineWithPointArray:self.upPointArray atContent:ctx color:[self.config ma10Color].CGColor];
    
    // mid
    [self p_drawLineWithPointArray:self.midPointArray atContent:ctx color:[self.config ma5Color].CGColor];
    
    // low
    [self p_drawLineWithPointArray:self.lowPointArray atContent:ctx color:[self.config ma30Color].CGColor];
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


// 绘制上方的详情视图
- (void)p_drawIndicatorDetailWithRect:(CGRect)rect {
    
    if (self.selectedModel) {
        
        NSString *indicatorName = @"BOLL(20,2)  ";
        
        NSString *mid = [NSString stringWithFormat:@"MID:%@ ",[@(self.selectedModel.ma20) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit]];
        
        NSString *up = [NSString stringWithFormat:@"UP:%@ ",[@(self.selectedModel.boll_up) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit]];
        
        NSString *lb = [NSString stringWithFormat:@"LB:%@",[@(self.selectedModel.boll_low) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit]];
        
        NSAttributedString *midAtt = [[NSAttributedString alloc] initWithString:mid attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma5Color]}];
        
        NSAttributedString *upAtt = [[NSAttributedString alloc] initWithString:up attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma10Color]}];
        
        NSAttributedString *lbAtt = [[NSAttributedString alloc] initWithString:lb attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma30Color]}];
        
        NSMutableAttributedString *mattirbuteStr = [[NSMutableAttributedString alloc] initWithString:indicatorName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:KColorTipText_999}];
        if (upAtt) {
            [mattirbuteStr appendAttributedString:upAtt];
        }
        
        if (midAtt) {
            [mattirbuteStr appendAttributedString:midAtt];
        }
        
        if (lbAtt) {
            [mattirbuteStr appendAttributedString:lbAtt];
        }
        
        [mattirbuteStr drawInRect:CGRectMake(rect.origin.x + 5.0, 0, rect.size.width - 5.0, 20.0)];
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
            
            if (tempModel.boll_up) {
                if (tempModel.boll_up > maxValue) {
                    maxValue = tempModel.boll_up;
                }
                if(tempModel.boll_up < minValue) {
                    minValue = tempModel.boll_up;
                }
            }
            
            if (tempModel.boll_low) {
                if (tempModel.boll_low > maxValue) {
                    maxValue = tempModel.boll_low;
                }
                if(tempModel.boll_low < minValue) {
                    minValue = tempModel.boll_low;
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

- (NSMutableArray *)midPointArray {
    if (!_midPointArray) {
        _midPointArray = @[].mutableCopy;
    }
    return _midPointArray;
}

- (NSMutableArray *)upPointArray {
    if (!_upPointArray) {
        _upPointArray = @[].mutableCopy;
    }
    return _upPointArray;
}

- (NSMutableArray *)lowPointArray {
    if (!_lowPointArray) {
        _lowPointArray = @[].mutableCopy;
    }
    return _lowPointArray;
}

@end
