//
//  KLineDateDrawLogic.m
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/2/14.
//  Copyright © 2019 walker. All rights reserved.
//

#import "KLineDateDrawLogic.h"
#import "DataCenter.h"

#define kHHmmWidth  (100.0f)
#define kYYMMWidth  (120.0f)

@interface KLineDateDrawLogic ()

/**
 每个item的宽度
 */
@property (assign, nonatomic) CGFloat perItemWidth;

/**
 K线实体线宽度
 */
@property (assign, nonatomic) CGFloat entityLineWidth;


@end

@implementation KLineDateDrawLogic

- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType{
    if (self = [super initWithRect:rect drawLogicIdentifier:identifier graphType:graphType]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
//    self.lineWidth = 1.0f;
    
//    NSLog(@"MA data prepare begin");
//    if(![[DataCenter shareCenter] isPrepareForDataType:IndicatorsDataTypeMA]){
//        [[DataCenter shareCenter] prepareDataWithType:IndicatorsDataTypeMA fromIndex:0];
//        NSLog(@"MA data prepare finish");
//    }
}

- (void)updateConfig:(NSObject<KLineViewProtocol> *)config {
    [super updateConfig:config];
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
    
    // 默认的K线间隔
    NSUInteger count = 5;
    CGFloat timeWidth = kHHmmWidth + [self.config dateMinGap];
    
    if ([DataCenter shareCenter].timeInterval >= 86400000) {
        // 日线或更大周期
        timeWidth = kYYMMWidth + [self.config dateMinGap];
    }
    
    while ((count * self.perItemWidth) < timeWidth) {
        count += 5;
    }
    
    // 计算
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        if (a % count == 0) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            
            
            
            
        }
    }
    
    
}


@end
