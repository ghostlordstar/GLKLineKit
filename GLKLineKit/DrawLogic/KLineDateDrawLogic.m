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
#define kMMddWidth  (120.0f)

@interface KLineDateDrawLogic ()

/**
 每个item的宽度
 */
@property (assign, nonatomic) CGFloat perItemWidth;

/**
 K线实体线宽度
 */
@property (assign, nonatomic) CGFloat entityLineWidth;

/**
 日期的描述集合
 */
@property (strong, nonatomic) NSMutableArray *dateStringArray;

/**
 开始绘制的横坐标
 */
@property (assign, nonatomic) CGRect beginDrawRect;

/* 日期的尺寸 */
@property (assign, nonatomic) CGFloat timeWidth;
@end

@implementation KLineDateDrawLogic

- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType{
    if (self = [super initWithRect:rect drawLogicIdentifier:identifier graphType:graphType]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
    self.dateStringArray = @[].mutableCopy;
    self.beginDrawRect = CGRectZero;
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
    self.timeWidth = kHHmmWidth + [self.config dateMinGap];
    BOOL isDayInterval = [DataCenter shareCenter].timeInterval >= 86400000; // 周期是否为日线及以上
    NSString *dateFormatter = @"HH:mm";
    if (isDayInterval) {
        // 日线或更大周期
        self.timeWidth = kMMddWidth + [self.config dateMinGap];
        dateFormatter = @"MM/dd";
    }
    
    while ((count * self.perItemWidth) < self.timeWidth) {
        count += 5;
    }
    
    [self.dateStringArray removeAllObjects];
    self.beginDrawRect = CGRectZero;
    
    // 计算
    for (NSInteger a = beginItemIndex; a <= endItemIndex; a ++) {
        if (a % count == 0) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
           
            NSString *tempDate = [NSString gl_convertTimeStamp:(tempModel.stamp / 1000) toFormatter:dateFormatter];
            
            if(CGRectEqualToRect(CGRectZero, self.beginDrawRect)) {
                
                if (a > count) {
                    KLineModel *firstModel = [DataCenter shareCenter].klineModelArray[a - count];
                    NSString *firstDate = [NSString gl_convertTimeStamp:(firstModel.stamp / 1000) toFormatter:dateFormatter];
                    [self.dateStringArray addObject:firstDate];
                }
                
                self.beginDrawRect = CGRectMake(((a - visibleRange.x) * self.perItemWidth) - (self.timeWidth / 2.0f) , self.logicRect.origin.y, self.timeWidth, 20.0f);
            }
            NSLog(@"show date -- index : %d,beginx:%f",a,visibleRange.x);

            [self.dateStringArray addObject:tempDate];

        }
    }
    
    // 开始绘制时间
    [self p_drawDateWithCtx:ctx];
}

/* 绘制时间 */
- (void)p_drawDateWithCtx:(CGContextRef)ctx {
    
    if (self.dateStringArray && self.dateStringArray.count > 0) {
        
        for (int i = 0; i < self.dateStringArray.count; i ++) {
            
            NSString *dateString = [self.dateStringArray objectAtIndex:i];
            CGRect drawRect = CGRectMake(self.beginDrawRect.origin.x + (i * self.timeWidth), self.beginDrawRect.origin.y, self.timeWidth, 20.0f);
            
            UIColor *color = KColorShort;
            if (i%2 == 0) {
                color = KColorLong;
            }
            
            [NSObject gl_drawBackGroundColorWithCtx:ctx rect:drawRect color:color];
            
            [NSObject gl_drawTextInRect:drawRect text:dateString attributes:@{}];
        }
    }
}

@end
