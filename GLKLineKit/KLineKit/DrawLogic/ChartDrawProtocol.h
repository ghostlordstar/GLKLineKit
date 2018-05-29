//
//  ChartDrawProtocol.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/1.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 绘图算法的协议，所有的绘图算法都要遵守，并且实现 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KLineViewProtocol.h"
#import "GLConstantDefinition.h"
@protocol ChartDrawProtocol <NSObject>

@required
/**
 根据上下文和绘制区域绘制图形
 */
- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments;

@end
