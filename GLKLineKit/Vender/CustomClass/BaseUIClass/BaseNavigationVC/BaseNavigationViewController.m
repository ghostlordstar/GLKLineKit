//
//  BaseNavigationViewController.m
//  GLKLineKit
//
//  Created by walker on 2018/5/30.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

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
    // 返回当前显示的viewController是否支持旋转
    return [self.visibleViewController shouldAutorotate];
}

/**
 支持的方向
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 返回当前显示的viewController支持旋转的方向
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

/**
 默认支持的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 返回当前显示的viewController是优先旋转的方向
    if (![self.visibleViewController isKindOfClass:[UIAlertController class]]) {
        return [self.visibleViewController supportedInterfaceOrientations];
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
