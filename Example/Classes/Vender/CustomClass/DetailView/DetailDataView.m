//
//  DetailDataView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "DetailDataView.h"

@interface DetailDataView ()

/**
 居左Text attributes
 */
@property (strong, nonatomic) NSDictionary *leftAttributes;


/**
 居右 Text attributes
 */
@property (strong, nonatomic) NSDictionary *rightAttributes;

/**
 contentArray
 */
@property (strong, nonatomic) NSArray *contentArray;

@end

@implementation DetailDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self p_initialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (!(self.contentArray && self.contentArray.count > 0)) {
        
        return;
    }
    
    [NSObject gl_drawTextBackGroundInRect:rect content:ctx boderColor:KColorSeparator_eee boderWidth:1.0f fillColor:[KColorNormalText_666 colorWithAlphaComponent:0.6]];
    
    for (NSInteger a = 0; a < self.contentArray.count; a ++) {
        DetailDataModel *tempModel = self.contentArray[a];
        CGRect textRect = CGRectMake(rect.origin.x + self.insets.left, a * self.rowHeight, rect.size.width - (self.insets.left + self.insets.right), self.rowHeight);
        
        [self p_drawContentWithDataModel:tempModel context:ctx textRect:textRect];
    }
}

/**
 更新内容
 
 @param models 内容数组
 */
- (void)updateContentWithDetailModels:(NSArray <DetailDataModel *>*)models {
    
    if (models && models.count > 0) {
        if (models.count != self.contentArray.count) {
            self.contentArray = [models copy];
            // 更新Frame
            [self p_updateFrame];
            
        }else {
            self.contentArray = [models copy];
        }
        
    }else {
        self.contentArray = @[];
    }
    

    
    [self setNeedsDisplay];
}

- (void)p_initialize {
    
    self.rowHeight = 20.0f;
    self.textFont = [UIFont systemFontOfSize:13.0f];
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.insets = UIEdgeInsetsMake(0, 2.0f, 0, 2.0f);
}

- (void)p_updateFrame {
    
    if (self.contentArray.count > 0) {
        CGRect newRect = self.frame;
        newRect.size.height = self.contentArray.count * self.rowHeight;
        self.frame = newRect;
    }
}

- (void)p_drawContentWithDataModel:(DetailDataModel *)model context:(CGContextRef)context textRect:(CGRect)textRect {
    
    if (!model) {
        return;
    }
    
//    [NSObject gl_drawTextInRect:textRect text:model.name attributes:self.leftAttributes];
    [NSObject gl_drawVerticalCenterTextInRect:textRect text:model.name attributes:self.leftAttributes];
    [NSObject gl_drawVerticalCenterTextInRect:textRect text:model.desc attributes:self.rightAttributes];

//    [NSObject gl_drawTextInRect:textRect text:model.desc attributes:self.rightAttributes];
    
}

#pragma mark - 懒加载 ---

- (NSArray *)contentArray {
    if (!_contentArray) {
        _contentArray = @[].mutableCopy;
    }
    return _contentArray;
}

- (NSDictionary *)leftAttributes {
    if (!_leftAttributes) {
        // 居中
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentLeft;
        // 属性：字体，颜色
        _leftAttributes = @{
                        NSFontAttributeName:self.textFont,       // 字体
                        NSForegroundColorAttributeName:self.textColor,   // 字体颜色
                        NSParagraphStyleAttributeName:style,   // 段落样式
                        };
    }
    return _leftAttributes;
}

- (NSDictionary *)rightAttributes {
    if (!_rightAttributes) {
        // 居右
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentRight;
        // 属性：字体，颜色
        _rightAttributes = @{
                            NSFontAttributeName:self.textFont,       // 字体
                            NSForegroundColorAttributeName:self.textColor,   // 字体颜色
                            NSParagraphStyleAttributeName:style,   // 段落样式
                            };
    }
    return _rightAttributes;
}

@end

@implementation DetailDataModel

- (instancetype)initWithName:(NSString *)name desc:(NSString *)desc {
    if (self = [super init]) {
        self.name = name;
        self.desc = desc;
    }
    return self;
}

@end
