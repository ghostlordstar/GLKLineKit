//
//  NSArray+Tools.h
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/3/11.
//  Copyright © 2019 walker. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Tools)

/**
 将touch集合 转换成点集合

 @param view 承载Touch的view
 @return CGPointValue 数组
 */
- (NSArray * _Nullable)gl_touchesConvertToPointValuesAtView:(UIView * _Nonnull)view;

@end

NS_ASSUME_NONNULL_END
