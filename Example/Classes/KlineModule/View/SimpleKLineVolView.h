//
//  SimpleKLineVolView.h
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleKLineVolView : UIView

/**
 数据中心
 */
@property (strong, nonatomic) DataCenter *dataCenter;

/**
 K线主图
 */
@property (strong, nonatomic) KLineView *kLineMainView;

/**
 K线副图(VOL)
 */
@property (strong, nonatomic) KLineView *volView;

/**
 切换主图样式
 */
- (void)switchKLineMainViewToType:(KLineMainViewType)type;

@end
