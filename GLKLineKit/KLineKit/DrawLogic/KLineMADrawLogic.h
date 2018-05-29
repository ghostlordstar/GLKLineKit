//
//  KLineMADrawLogic.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/19.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* MA(5,10,30)绘图算法 */

#import "BaseDrawLogic.h"

@interface KLineMADrawLogic : BaseDrawLogic

#pragma mark - 下方隐藏各MA线方法主要是为了配合分时图使用，因为一般分时图只会有一根MA线，可以根据需求隐藏不需要的线 ---

/**
 隐藏ma5

 @param hide 是否隐藏，传YES隐藏，默认为NO
 */
- (void)setMa5Hiden:(BOOL)hide;

/**
 隐藏ma10
 
 @param hide 是否隐藏，传YES隐藏，默认为NO
 */
- (void)setMa10Hiden:(BOOL)hide;

/**
 隐藏ma30
 
 @param hide 是否隐藏，传YES隐藏，默认为NO
 */
- (void)setMa30Hiden:(BOOL)hide;

@end
