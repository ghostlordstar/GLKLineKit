//
//  KLineKDJDrawLogic.m
//  KLineDemo
//
//  Created by walker on 2018/5/22.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//


#import "KLineKDJDrawLogic.h"
#import "DataCenter.h"
#import "NSValue+GLExtremeValue.h"

@interface KLineKDJDrawLogic ()

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
 K点的集合
 */
@property (strong, nonatomic) NSMutableArray *kPointArray;

/**
 D点的集合
 */
@property (strong, nonatomic) NSMutableArray *dPointArray;

/**
 J点的集合
 */
@property (strong, nonatomic) NSMutableArray *jPointArray;

/**
 选中的模型
 */
@property (strong, nonatomic) KLineModel *selectedModel;
@end

@implementation KLineKDJDrawLogic

- (instancetype)initWithDrawLogicIdentifier:(NSString *)identifier {
    if (self = [super initWithDrawLogicIdentifier:identifier]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.lineWidth = 1.0f;
    
    NSLog(@"KDJ data prepare begin");
    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeKDJ]){
        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeKDJ fromIndex:0];
        NSLog(@"KDJ data prepare finish");
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
    
    [self.kPointArray removeAllObjects];
    [self.dPointArray removeAllObjects];
    [self.jPointArray removeAllObjects];
    
    // 计算绘图的x值
    CGFloat drawX = - (self.perItemWidth * (visibleRange.x - beginItemIndex));
    
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        // 中心x值
        CGFloat centerX = drawX + (self.perItemWidth / 2.0);
        
        // K的点
        CGFloat kPointY = rect.size.height * (1.0f - (tempModel.k - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
        NSValue *kPointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, kPointY)];
        [self.kPointArray addObject:kPointValue];
        
        
        // D的点
        CGFloat dPointY = rect.size.height * (1.0f - (tempModel.d - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
        NSValue *dPointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, dPointY)];
        
        [self.dPointArray addObject:dPointValue];
        
        // J的点
        CGFloat jPointY = rect.size.height * (1.0f - (tempModel.j - self.extremeValue.minValue) / diffValue) + rect.origin.y ;
        NSValue *jPointValue = [NSValue valueWithCGPoint:CGPointMake(centerX, jPointY)];
        
        [self.jPointArray addObject:jPointValue];
        
        drawX += self.perItemWidth;
    }
    
    // K
    [self p_drawLineWithPointArray:self.kPointArray atContent:ctx color:[self.config ma5Color].CGColor];
    
    // D
    [self p_drawLineWithPointArray:self.dPointArray atContent:ctx color:[self.config ma10Color].CGColor];
    
    // J
    [self p_drawLineWithPointArray:self.jPointArray atContent:ctx color:[self.config ma30Color].CGColor];
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
            
            if (tempModel.k > maxValue) {
                maxValue = tempModel.k;
            }
            if(tempModel.k < minValue) {
                minValue = tempModel.k;
            }
            
            if (tempModel.d > maxValue) {
                maxValue = tempModel.d;
            }
            if(tempModel.d < minValue) {
                minValue = tempModel.d;
            }
            
            if (tempModel.j > maxValue) {
                maxValue = tempModel.j;
            }
            if(tempModel.j < minValue) {
                minValue = tempModel.j;
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
        
        NSString *indicatorName = @"KDJ(9,3,3)  ";
        
        NSString *k_str = [NSString stringWithFormat:@"K:%@ ",[@(self.selectedModel.k) gl_numberToStringWithDecimalsLimit:6]];
        
        NSString *d_str = [NSString stringWithFormat:@"D:%@ ",[@(self.selectedModel.d) gl_numberToStringWithDecimalsLimit:6]];
        
        NSString *j_str = [NSString stringWithFormat:@"J:%@",[@(self.selectedModel.j) gl_numberToStringWithDecimalsLimit:6]];
        
        NSAttributedString *k_Att = [[NSAttributedString alloc] initWithString:k_str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma5Color]}];
        
        NSAttributedString *d_Att = [[NSAttributedString alloc] initWithString:d_str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma10Color]}];
        
        NSAttributedString *j_Att = [[NSAttributedString alloc] initWithString:j_str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:[self.config ma30Color]}];
        
        NSMutableAttributedString *mattirbuteStr = [[NSMutableAttributedString alloc] initWithString:indicatorName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:KColorTipText_999}];
        
        if (k_Att) {
            [mattirbuteStr appendAttributedString:k_Att];
        }
        
        if (d_Att) {
            [mattirbuteStr appendAttributedString:d_Att];
        }
        
        if (j_Att) {
            [mattirbuteStr appendAttributedString:j_Att];
        }
        
        [mattirbuteStr drawInRect:CGRectMake(rect.origin.x + 5.0, 0, rect.size.width - 5.0, 20.0)];
    }
}




- (NSMutableArray *)kPointArray {
    if (!_kPointArray) {
        _kPointArray = @[].mutableCopy;
    }
    return _kPointArray;
}

- (NSMutableArray *)dPointArray {
    if (!_dPointArray) {
        _dPointArray = @[].mutableCopy;
    }
    return _dPointArray;
}

- (NSMutableArray *)jPointArray {
    if (!_jPointArray) {
        _jPointArray = @[].mutableCopy;
    }
    return _jPointArray;
}

@end
