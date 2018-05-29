//
//  BothController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "BothController.h"

@interface BothController ()

@end

@implementation BothController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - 私有方法 ---

- (void)p_initialize {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"横竖屏切换";
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


@end
