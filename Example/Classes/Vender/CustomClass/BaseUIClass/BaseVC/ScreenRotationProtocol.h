//
//  ScreenRotationProtocol.h
//  GLKLineKit
//
//  Created by walker on 2018/5/30.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScreenRotationProtocol <NSObject>
@required
/**
 是否需要旋转
 */
- (BOOL)shouldAutorotate;

/**
 支持的方向
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

/**
 默认支持的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
@end
