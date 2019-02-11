//
//  NewSimpleKlineView.h
//  GLKLineKit
//
//  Created by 幽雅的暴君 on 2019/2/11.
//  Copyright © 2019 walker. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewSimpleKlineView : BaseView
/**
 数据中心
 */
@property (strong, nonatomic) DataCenter *dataCenter;

/**
 K线主图
 */
@property (strong, nonatomic) KLineView *kLineMainView;

/**
 切换主图样式
 */
- (void)switchKLineMainViewToType:(KLineMainViewType)type;

@end

NS_ASSUME_NONNULL_END
