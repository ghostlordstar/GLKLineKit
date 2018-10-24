//
//  KLineBGDrawLogic.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/16.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 分割线和刻度绘图算法 */

#import "BaseDrawLogic.h"
/*同级不引用的类的数据交互*/
@interface KLineBGDrawLogic : BaseDrawLogic

/**
 是否隐藏中间刻度显示
 默认为NO，不隐藏
 */
@property (assign, nonatomic) BOOL isHideMidDial;

@end
