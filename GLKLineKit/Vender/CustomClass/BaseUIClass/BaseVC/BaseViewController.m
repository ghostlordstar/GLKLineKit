//
//  BaseViewController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/30.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 屏幕旋转 ---

/**
 是否需要旋转
 */
- (BOOL)shouldAutorotate {
    return NO;
}

/**
 支持的方向
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

/**
 默认支持的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

@end
