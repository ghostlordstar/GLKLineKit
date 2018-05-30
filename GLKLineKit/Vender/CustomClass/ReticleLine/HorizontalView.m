//
//  HorizontalView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/26.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "HorizontalView.h"

@interface HorizontalView ()

/**
 需要绘制的文字
 */
@property (copy, nonatomic) NSString *text;

/**
 当前正在显示的文字
 */
@property (copy, nonatomic) NSString *displayingText;

/**
 文字显示的区域
 */
@property (assign, nonatomic) CGRect textRect;

/**
 horizontalLine height
 默认高度 1.0f
 */
@property (assign, nonatomic) CGFloat horizontalLineHeight;

/**
 文字的边距
 默认为 {1.0f,1.0f,1.0f,1.0f}
 */
@property (assign, nonatomic) UIEdgeInsets textInsets;

/**
 属性字符串
 */
@property (strong, nonatomic) NSDictionary *attributes;
@end

@implementation HorizontalView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 设置初始化参数
        [self p_initialization];
        // 设置基础UI
        [self p_setUpBaseUI];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 绘制文字
    self.textRect = [self p_drawTextWithContent:ctx textRect:rect];
    
}

#pragma mark - 赋值或set方法 ----
- (void)setIsShowBorder:(BOOL)isShowBorder {
    
    if (_isShowBorder != isShowBorder) {
        _isShowBorder = isShowBorder;
        
        [self setNeedsDisplay];
    }
    
}
#pragma mark - 公共方法 -----

- (void)updateText:(NSString *)text {
    
    if (text && text.length >= 1) {
        _text = [text copy];
    }else {
        _text = @"--";
    }
    
    [self setNeedsDisplay];
}

- (CGSize)getCurrentTextSize {
    CGSize textSize;
    
    // 计算字体的大小
    textSize = [_text sizeWithAttributes:self.attributes];
    
    return textSize;
}

#pragma mark - 私有方法 ----

/**
 初始化参数
 */
- (void)p_initialization {
    self.backgroundColor = [UIColor clearColor];
    self.isShowBorder = YES;
    self.text = @"--";
    self.textColor = [UIColor whiteColor];
    self.horizontalLineHeight = 1.0f;
    self.textInsets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
}

/**
 设置基础UI
 */
- (void)p_setUpBaseUI {
    [self setNeedsDisplay];
}

/**
 绘制横线：暂时不用
 
 @param ctx 上下文
 */
- (void)p_drawHorizontalLineWithContent:(CGContextRef)ctx rect:(CGRect)rect {
    // 设置线宽
    CGContextSetLineWidth(ctx, self.horizontalLineHeight);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    // 计算横线的起始高度
    CGFloat originY = (rect.size.height / 2.0) + rect.origin.y;
    
    // 横线起点
    CGContextMoveToPoint(ctx, rect.origin.x, originY);
    
    if(!isnan(originY)) {
        // 终点
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), originY);
    }
    
    // 绘制
    CGContextStrokePath(ctx);
}


/**
 绘制文字
 
 @param ctx 上下文
 @param rect 文字绘制区域
 @return CGRect 文字最终的绘制区域
 */
- (CGRect)p_drawTextWithContent:(CGContextRef)ctx textRect:(CGRect)rect {
    
    // 记录正在显示的text
    self.displayingText = self.text;
    
    CGSize textSize = [self getCurrentTextSize];
    
    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);
    
    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(rect.origin.x, originY , textSize.width , textSize.height );
    
    // 绘制文字背景
    [self drawTextBackGroundInRect:CGRectMake(textRect.origin.x, 0, textRect.size.width, rect.size.height) content:ctx];
    
    // 绘制字体
    [self.text drawInRect:textRect withAttributes:self.attributes];
    
    return textRect;
}


/**
 绘制文字的背景框
 
 @param bgRect 背景框的尺寸
 @param ctx 绘图上下文
 @return 文字背景的尺寸
 */
- (CGRect)drawTextBackGroundInRect:(CGRect)bgRect content:(CGContextRef)ctx {
    // 设置线宽
    CGContextSetLineWidth(ctx, 0.5f);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    // 添加矩形
    CGContextAddRect(ctx, bgRect);
    // 添加填充颜色
    CGContextSetFillColorWithColor(ctx, [[UIColor darkGrayColor] colorWithAlphaComponent:0.8].CGColor);
    // 绘制填充
    CGContextFillPath(ctx);
    
    // 添加矩形
    CGContextAddRect(ctx, bgRect);
    // 绘制边框
    CGContextStrokePath(ctx);
    
    return bgRect;
}

#pragma mark - 懒加载 ---------

- (NSDictionary *)attributes {
    if (!_attributes) {
        // 居中
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentLeft;
        // 属性：字体，颜色，居中
        _attributes = @{
                        NSFontAttributeName:[UIFont systemFontOfSize:13.0f],       // 字体
                        NSForegroundColorAttributeName:self.textColor,   // 字体颜色
                        NSParagraphStyleAttributeName:style,   // 段落样式
                        };
    }
    return _attributes;
}

@end
