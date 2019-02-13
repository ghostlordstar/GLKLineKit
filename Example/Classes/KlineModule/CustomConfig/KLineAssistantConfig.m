//
//  KLineAssistantConfig.m
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/2/13.
//  Copyright © 2019 walker. All rights reserved.
//

#import "KLineAssistantConfig.h"

@implementation KLineAssistantConfig

- (UIEdgeInsets)insetsOfKlineView {
    
    CGFloat borderWidth = [self borderWidth];
    
    return UIEdgeInsetsMake(20.0f + borderWidth, borderWidth, borderWidth, borderWidth);
}

- (UIEdgeInsets)insetsOfBorder {
    
    CGFloat borderWidth = [self borderWidth];
    
    return UIEdgeInsetsMake(borderWidth, borderWidth, borderWidth, borderWidth);
}

@end
