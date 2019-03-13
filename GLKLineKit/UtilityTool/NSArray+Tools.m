//
//  NSArray+Tools.m
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/3/11.
//  Copyright © 2019 walker. All rights reserved.
//

#import "NSArray+Tools.h"

@implementation NSArray (Tools)

/**
 将touch集合 转换成点集合
 
 @param view 承载Touch的view
 @return CGPointValue 数组
 */
- (NSArray * _Nullable)gl_touchesConvertToPointValuesAtView:(UIView * _Nonnull)view {
    
    NSMutableArray *pointValues = @[].mutableCopy;

    if (self.count > 0) {
        
        for (int i = 0; i < self.count ; i ++) {
            UITouch *touch = [self objectAtIndex:i];
            if (touch && [touch isKindOfClass:[UITouch class]]) {
                CGPoint tempPoint = [touch locationInView:view];
                
                [pointValues addObject:[NSValue valueWithCGPoint:tempPoint]];
            }
        }
    }

    return [NSArray arrayWithArray:pointValues];
}

@end
