//
//  UIFont+ScaleSize.h
//  kkcoin
//
//  Created by kk_ghostlord on 2018/4/11.
//  Copyright © 2018年 董. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ScaleSize)

/**
 根据设备尺寸适配字体大小

 @param size 字体大小
 @return 字体对象
 */
+ (instancetype)kk_systemFontOfSize:(CGFloat)size;

/**
 根据设备尺寸适配字体大小
 
 @param size 字体大小
 @return 加粗字体对象
 */
+ (instancetype)kk_boldSystemFontOfSize:(CGFloat)size;

@end
