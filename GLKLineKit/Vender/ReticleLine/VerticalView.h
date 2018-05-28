//
//  VerticalView.h
//  GLKLineKit
//
//  Created by walker on 2018/5/26.
//  Copyright © 2018年 walker. All rights reserved.
//
/* 十字线垂直线 */

#import <UIKit/UIKit.h>

@interface VerticalView : UIView
/**
 文字是否需要边框
 默认显示边框
 */
@property (assign, nonatomic) BOOL isShowBorder;

/**
 文字颜色
 */
@property (strong, nonatomic) UIColor *textColor;


/**
 更新文字

 @param text 文字
 */
- (void)updateText:(NSString *)text;

/**
 更新文字区域中心点的x

 @param textCenterX 文字区域的中心点x值
 */
- (void)updateTextCenterX:(CGFloat)textCenterX;

/**
 更新文字
 
 @param text 文字
 @param textCenterX 文字区域的中心点x值
 */
- (void)updateText:(NSString *)text textCenterX:(CGFloat)textCenterX;


@end
