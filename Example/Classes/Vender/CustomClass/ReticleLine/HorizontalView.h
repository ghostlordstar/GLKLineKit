//
//  HorizontalView.h
//  GLKLineKit
//
//  Created by walker on 2018/5/26.
//  Copyright © 2018年 walker. All rights reserved.
//
/* 十字线水平线 */

#import <UIKit/UIKit.h>

@interface HorizontalView : UIView

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
 获得当前绘制文字区域的大小

 @return 文字区域大小
 */
- (CGSize)getCurrentTextSize;

@end
