//
//  FullScreenKLineView.h
//  GLKLineKit
//
//  Created by walker on 2018/5/30.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenKLineView : UIView
/**
 数据中心
 */
@property (strong, nonatomic) DataCenter *dataCenter;

/**
 K线主图
 */
@property (strong, nonatomic) KLineView *kLineMainView;

/** 当前的主图样式 */
@property (readonly, assign, nonatomic) KLineMainViewType mainViewType;

/** 当前的附图样式 */
@property (readonly, assign, nonatomic) KLineAssistantViewType assistantViewType;

/**
 切换主图样式，默认是K线
 */
- (void)switchKLineMainViewToType:(KLineMainViewType)type;

/**
 切换附图样式，默认是VOL+MA
 */
- (void)switchKlineAssistantViewToType:(KLineAssistantViewType)type;
@end
