//
//  KLineVolDrawLogic.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/19.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 成交量绘图算法 */

#import "BaseDrawLogic.h"

@interface KLineVolDrawLogic : BaseDrawLogic

/* 绘制时底部是否从0开始，默认为YES */
@property (assign, nonatomic) BOOL isBeginZero;

@end
