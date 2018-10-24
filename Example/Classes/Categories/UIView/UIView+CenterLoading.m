//
//  UIView+CenterLoading.m
//  NewTestDemo
//
//  Created by kk_ghostlord on 2018/4/19.
//  Copyright © 2018年 ghostlord. All rights reserved.
//

#import "UIView+CenterLoading.h"
#import <objc/message.h>
static char *gl_loadingPropertyKey = "gl_loadingPropertyKey";
@implementation UIView (CenterLoading)

#pragma mark - 公共方法 ----
/**
 开始动画
 */
- (void)gl_startAnimating {
    
    [self gl_startAnimatingWithOffset:CGPointZero activityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
}

/**
 开始动画
 
 @param offset 动画距离中心点的偏移量
 */
- (void)gl_startAnimatingWithOffset:(CGPoint)offset {
    
    [self gl_startAnimatingWithOffset:offset activityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
}

/**
 开始动画

 @param center loading动画的中心点
 */
- (void)gl_startAnimatingWithCenter:(CGPoint)center {
    
    [self gl_startAnimatingWithCenter:center activityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
     
}

/**
 开始动画
 
 @param offset 动画距离中心点的偏移量
 @param style loading动画的样式
 */
- (void)gl_startAnimatingWithOffset:(CGPoint)offset activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style {
    
    self.gl_loadingView = [self p_gl_createLoadingView];
    if (self.gl_loadingView) {
        self.gl_loadingView.activityIndicatorViewStyle = style;
        self.gl_loadingView.hidden = NO;
        [self gl_setUpLayoutWithOffset:offset];
        [self.gl_loadingView startAnimating];
    }
}

/**
 开始动画
 
 @param center 动画距离中心点的偏移量
 @param style loading动画的样式
 */
- (void)gl_startAnimatingWithCenter:(CGPoint)center activityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style {
    
    self.gl_loadingView = [self p_gl_createLoadingView];
    if (self.gl_loadingView) {
        self.gl_loadingView.activityIndicatorViewStyle = style;
        self.gl_loadingView.hidden = NO;
        [self gl_setUpLayoutWithCenter:center];
        [self.gl_loadingView startAnimating];
    }
}

/**
 结束动画
 */
- (void)gl_stopAnimating {
    
    if (self.gl_loadingView) {
        [self.gl_loadingView stopAnimating];
        self.gl_loadingView.hidden = YES;
        [self.gl_loadingView removeFromSuperview];
        self.gl_loadingView = nil;
    }
}

/**
 根据偏移量布局
 */
- (void)gl_setUpLayoutWithOffset:(CGPoint)offset {
    
    if(![self.subviews containsObject:self.gl_loadingView]) {
        [self addSubview:self.gl_loadingView];
    }
    
    [self bringSubviewToFront:self.gl_loadingView];
    
    // 添加约束
    self.gl_loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(self.gl_loadingView) {
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.gl_loadingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:(offset.x)];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.gl_loadingView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:(offset.y)];
        [self addConstraints:@[centerX,centerY]];
    }

}


/**
 根据中心点布局

 @param center loading图的中心
 */
- (void)gl_setUpLayoutWithCenter:(CGPoint)center {
    
    if(![self.subviews containsObject:self.gl_loadingView]) {
        [self addSubview:self.gl_loadingView];
    }
    
    [self bringSubviewToFront:self.gl_loadingView];
    
    // 添加约束
    self.gl_loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(self.gl_loadingView) {
        NSLayoutConstraint *originX = [NSLayoutConstraint constraintWithItem:self.gl_loadingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:(center.x)];
        NSLayoutConstraint *originY = [NSLayoutConstraint constraintWithItem:self.gl_loadingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:(center.y)];
        [self addConstraints:@[originX,originY]];
    }
}

#pragma mark - 私有方法 ----

/**
 创建loading动画控件
 */
- (UIActivityIndicatorView *)p_gl_createLoadingView {
    UIActivityIndicatorView *loadingView = self.gl_loadingView;
    if (!loadingView) {
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingView.backgroundColor = [UIColor clearColor];
    }

    return loadingView;
}

#pragma mark - 属性绑定 ----

- (void)setGl_loadingView:(UIActivityIndicatorView *)gl_loadingView {
    
    if (gl_loadingView && [gl_loadingView isKindOfClass:[UIActivityIndicatorView class]]) {
        /**
         object : 需要绑定属性的对象
         key    : 属性对应的key
         value  : 属性赋值
         policy : 属性修饰词
         */
        objc_setAssociatedObject(self, gl_loadingPropertyKey, gl_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIActivityIndicatorView *)gl_loadingView {
    
    return objc_getAssociatedObject(self, gl_loadingPropertyKey);
}
@end
