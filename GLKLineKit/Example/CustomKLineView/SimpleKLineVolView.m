//
//  SimpleKLineVolView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "SimpleKLineVolView.h"

@interface SimpleKLineVolView ()




@end

@implementation SimpleKLineVolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - 布局方法  -------

- (void)setUpUI {
    self.backgroundColor = [UIColor blackColor];
    
    [self layoutWithMasonry];
}


- (void)layoutWithMasonry {
    
    
}


#pragma mark - 赋值或set方法 ----

#pragma mark - 公共方法 -----

#pragma mark - 私有方法 ----

#pragma mark - 懒加载 ---------


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

@end
