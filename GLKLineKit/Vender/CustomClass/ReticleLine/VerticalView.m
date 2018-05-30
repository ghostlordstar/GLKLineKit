//
//  VerticalView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/26.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "VerticalView.h"
@interface VerticalView ()

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
 文字的边距
 默认为 {1.0f,1.0f,1.0f,1.0f}
 */
@property (assign, nonatomic) UIEdgeInsets textInsets;

/**
 文字区域中心点的x值
 */
@property (assign, nonatomic) CGFloat textCenterX;

@end
@implementation VerticalView

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
    // 绘图上下文
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


/**
 更新文字
 
 @param text 文字
 */
- (void)updateText:(NSString *)text {
    if (text && text.length >= 1) {
        _text = [text copy];
    }else {
        _text = @"--";
    }
    
    [self setNeedsDisplay];
}

/**
 更新文字区域中心点的x
 
 @param textCenterX 文字区域的中心点x值
 */
- (void)updateTextCenterX:(CGFloat)textCenterX {
    // 文字区域中心点的x值
    self.textCenterX = textCenterX;
    
    [self setNeedsDisplay];
}

/**
 更新文字
 
 @param text 文字
 @param textCenterX 文字区域的中心点x值
 */
- (void)updateText:(NSString *)text textCenterX:(CGFloat)textCenterX {
    
    [self updateText:text];
    
    [self updateTextCenterX:textCenterX];
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
    self.textInsets = UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f);
    self.textCenterX = 0.0f;
}

/**
 设置基础UI
 */
- (void)p_setUpBaseUI {
    [self setNeedsDisplay];
}

#pragma mark - 绘制方法 ---

/**
 绘制文字
 
 @param ctx 上下文
 @param rect 文字绘制区域
 @return CGRect 文字最终的绘制区域
 */
- (CGRect)p_drawTextWithContent:(CGContextRef)ctx textRect:(CGRect)rect {
    
    // 记录正在显示的text
    self.displayingText = self.text;
    
    // 居中
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    // 属性：字体，颜色，居中
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],       // 字体
                                 NSForegroundColorAttributeName:self.textColor,   // 字体颜色
                                 NSParagraphStyleAttributeName:style,   // 段落样式
                                 };

    // 计算字体的大小
    CGSize textSize = [self.text sizeWithAttributes:attributes];

    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);

    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(rect.origin.x, originY , textSize.width , rect.size.height);
    // 根据传入的中心点的x值修正绘制区域
    textRect = [self p_repairTextRect:textRect textCenterX:self.textCenterX];
    
    // 绘制文字背景
    [self p_drawTextBackGroundInRect:CGRectMake(textRect.origin.x, 0, textRect.size.width, rect.size.height) content:ctx];
    
    // 绘制字体
    [self.text drawInRect:textRect withAttributes:attributes];
    
    return textRect;
}

/**
 绘制文字的背景框
 
 @param bgRect 背景框的尺寸
 @param ctx 绘图上下文
 @return 文字背景的尺寸
 */
- (CGRect)p_drawTextBackGroundInRect:(CGRect)bgRect content:(CGContextRef)ctx {
    // 设置线宽
    CGContextSetLineWidth(ctx, 0.5);
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

/**
 根据文字区域中心的x值修正文字绘制区域

 @param textRect 未修正的文字区域
 @param textCenterX 文字区域中心的x值
 @return CGRect 修正后的文字区域
 */
- (CGRect)p_repairTextRect:(CGRect)textRect textCenterX:(CGFloat)textCenterX {
    
    CGRect newRect = textRect;
    newRect.origin.x = textCenterX - (textRect.size.width / 2.0);
    if (newRect.origin.x <= 0) {
        newRect.origin.x = 0;
    }else if (CGRectGetMaxX(newRect) >= self.frame.size.width) {
        newRect.origin.x = self.frame.size.width - newRect.size.width;
    }

    return newRect;
}

@end
