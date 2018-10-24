//
//  UIView+CenterLoading.h
//  NewTestDemo
//
//  Created by kk_ghostlord on 2018/4/19.
//  Copyright © 2018年 ghostlord. All rights reserved.
//

/**
 给每个UIView 展示loading图
 调用 gl_startAnimating 方法时会生成一个UIActivityIndicatorView对象并开始动画
 调用 gl_startAnimatingWithOffset:activityIndicatorViewStyle:方法可以自定义动画的中心位置和动画的样式
 调用 gl_stopAnimating 方法停止动画并隐藏 UIActivityIndicatorView 对象
 */

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (CenterLoading)

/**
 loading 视图
 */
@property (nullable, readonly, strong, nonatomic) UIActivityIndicatorView *gl_loadingView;

/**
 开始动画
 */
- (void)gl_startAnimating;

/**
 开始动画

 @param offset 动画距离中心点的偏移量
 */
- (void)gl_startAnimatingWithOffset:(CGPoint)offset;

/**
 开始动画
 
 @param center loading图的中心点
 */
- (void)gl_startAnimatingWithCenter:(CGPoint)center;

/**
 开始动画

 @param offset 动画距离中心点的偏移量
 @param style loading动画的样式
 */
- (void)gl_startAnimatingWithOffset:(CGPoint)offset activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style;

/**
 开始动画
 
 @param center 动画中心点
 @param style loading动画的样式
 */
- (void)gl_startAnimatingWithCenter:(CGPoint)center activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style;

/**
 结束动画
 */
- (void)gl_stopAnimating;

@end
NS_ASSUME_NONNULL_END
