//
//  KLineBGDrawLogic.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineBGDrawLogic.h"
#import "DataCenter.h"
#import "NSNumber+StringFormatter.h"
@interface KLineBGDrawLogic ()

/**
 最大最小值
 */
@property (assign, nonatomic) GLExtremeValue extremeValue;

/**
 水平分割线高度的集合
 */
@property (strong, nonatomic) NSMutableArray *horizontalYArray;

@end

@implementation KLineBGDrawLogic

- (instancetype)initWithDrawLogicIdentifier:(NSString *)identifier {
    if (self = [super initWithDrawLogicIdentifier:identifier]) {
        [self p_initialization];
    }
    return self;
}

- (void)p_initialization {
    
}

/**
 根据上下文和绘制区域绘制图形
 */
- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments {

    // 根据传入的参数更新最大最小值
    [self p_updateExtremeValueWithArguments:arguments];
    
    if ([self.config isHaveBorder]) {
        // 绘制边框
        [self p_drawBorderWithContext:ctx rect:rect];
    }
    
    // 绘制分割线
    [self p_drawSeparatorWithContext:ctx rect:rect];
    
    if ([DataCenter shareCenter].klineModelArray.count >= 1) {
        
        // 绘制刻度
        [self p_drawValueWithContext:ctx rect:rect];
    }
}


/**
 绘制边框
 
 @param ctx 绘制边框的上下文
 @param rect 绘制边框的区域
 */
- (void)p_drawBorderWithContext:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat borderWidth = [self.config borderWidth];
    if (borderWidth <= 0.0f) {
        NSLog(@"传入的边框宽度 <= 0,无需绘制");
        return;
    }
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, borderWidth);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, [self.config borderColor].CGColor);
    // 添加矩形
    CGContextAddRect(ctx, rect);
    // 绘制边框
    CGContextStrokePath(ctx);
}


/**
 绘制分割线
 
 @param ctx 上下文
 @param rect 绘制区域
 */
- (void)p_drawSeparatorWithContext:(CGContextRef)ctx rect:(CGRect)rect {
    NSInteger h_sep_count = [self.config horizontalSeparatorCount];
    NSInteger v_sep_count = [self.config verticalSeparatorCount];
    
    if (h_sep_count <= 0 && v_sep_count <= 0) {
        NSLog(@"传入的分割线条数为 0 ,不需绘制");
        return;
    }
    [self.horizontalYArray removeAllObjects];
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, 1.0f);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor);
    
    // 水平分割线
    if (h_sep_count >= 1) {
        // 每个分割线之间的宽度
        CGFloat perH = rect.size.height / (h_sep_count + 1);
        
        for (int a = 0; a < h_sep_count; a ++) {
            
            [self.horizontalYArray addObject:@(perH * (a + 1))];
            // 起点
            CGContextMoveToPoint(ctx, rect.origin.x, perH * (a + 1));
            // 终点
            CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, perH * (a + 1));
            // 绘制边框
            CGContextStrokePath(ctx);
        }
    }
    
    // 垂直分割线
    if (v_sep_count >= 1) {
        
        // 每个分割线之间的宽度
        CGFloat perW = rect.size.width / (v_sep_count + 1);
        
        for (int a = 0; a < v_sep_count; a ++) {
            // 起点
            CGContextMoveToPoint(ctx, rect.origin.x + perW * (a + 1), rect.origin.y + rect.size.height);
            // 终点
            CGContextAddLineToPoint(ctx, rect.origin.x + perW * (a + 1), rect.origin.y);
            // 绘制边框
            CGContextStrokePath(ctx);
        }
    }
}


/**
 绘制刻度
 
 @param ctx 上下文
 @param rect 文字区域
 */
- (void)p_drawValueWithContext:(CGContextRef)ctx rect:(CGRect)rect {
    
    if (self.extremeValue.maxValue <= self.extremeValue.minValue) {
        NSLog(@"最大最小值都为0，不需绘制");
        return;
    }
    // 小数点位数限制
    NSInteger decimalsLimit = [DataCenter shareCenter].decimalsLimit;
    // 文本区域高度
    CGFloat textRectHeight = 20.0f;
    
    // 文本区域
    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, textRectHeight);
    // 居中
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentRight;
    // 属性：字体，颜色，居中
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],       // 字体
                                 NSForegroundColorAttributeName:KColorNormalText_666,   // 字体颜色
                                 NSParagraphStyleAttributeName:style,   // 段落样式
                                 };
    
    if(self.horizontalYArray.count >= 1 && !self.isHideMidDial) {
        // 每个格占的值
        double perValue = (self.extremeValue.maxValue - self.extremeValue.minValue) / (self.horizontalYArray.count + 1);

        // 水平分割线刻度展示
        for (int a = 0; a < self.horizontalYArray.count ; a ++) {
            CGFloat currentY = [(NSNumber *)self.horizontalYArray[a] floatValue];
            textRect.origin.y = currentY - textRectHeight;
            [self p_drawTextInRect:textRect text: [@(self.extremeValue.maxValue - (perValue * (a + 1))) gl_numberToStringWithDecimalsLimit:decimalsLimit] attributes:attributes];
        }
    }

    // 最大值
    textRect.origin.y = rect.origin.y;
    [self p_drawTextInRect:textRect text:[@(self.extremeValue.maxValue) gl_numberToStringWithDecimalsLimit:decimalsLimit] attributes:attributes];
    // 最小值
    textRect.origin.y = CGRectGetMaxY(rect) - textRectHeight;
    [self p_drawTextInRect:textRect text:[@(self.extremeValue.minValue) gl_numberToStringWithDecimalsLimit:decimalsLimit] attributes:attributes];

}


/**
 绘制一个左右和垂直居中的文字
 
 @param rect 绘制的区域
 @param text 绘制的文字
 @param attributes 文字的样式
 */
- (void)p_drawTextInRect:(CGRect)rect text:(NSString *)text attributes:(NSDictionary *)attributes {
    
    // 计算字体的大小
    CGSize textSize = [text sizeWithAttributes:attributes];
    
    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);
    
    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(rect.origin.x, originY, rect.size.width, textSize.height);
    
    // 绘制字体
    [text drawInRect:textRect withAttributes:attributes];
}

/**
 根据传入的参数更新最大最小值
 
 @param argu 传入的参数
 */
- (void)p_updateExtremeValueWithArguments:(NSDictionary *)argu {
    
    if(argu && [argu isKindOfClass:[NSDictionary class]]) {
        
        NSValue *tempExtremeValue = [argu objectForKey:KlineViewToKlineBGDrawLogicExtremeValueKey];
        
        self.extremeValue = [tempExtremeValue gl_extremeValue];
    }
}

- (NSMutableArray *)horizontalYArray {
    if (!_horizontalYArray) {
        _horizontalYArray = @[].mutableCopy;
    }
    return _horizontalYArray;
}

@end
