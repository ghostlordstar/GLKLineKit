//
//  ListMenuView.h
//  GLKLineKit
//
//  Created by walker on 2018/5/31.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class ListMenuView;
@protocol ListMenuViewProtocol <NSObject>

/**
 被选中的选项

 @param view 选项列表视图
 @param indexPath 选择的位置
 @param title 选项的标题
 */
- (void)listMenuView:(ListMenuView *)view didSelectedAtIndexPath:(NSIndexPath *)indexPath itemTitle:(NSString *)title;

/**
 选项的标题集合

 @param view 选项列表视图
 */
- (NSArray *)itemTitlesAtListMenuView:(ListMenuView *)view;


@end

/**
 简单列表视图
 */
@interface ListMenuView : UIView

/**
 视图的唯一标识符
 */
@property (readonly, copy, nonatomic) NSString *identifier;

/**
 代理
 */
@property (weak, nonatomic) id<ListMenuViewProtocol> delegate;

/**
 是否有分割线
 */
@property (assign, nonatomic) BOOL isShowSeparator;

/**
 初始化方法

 @param frame 尺寸
 @param identifier 标识符
 */
- (instancetype)initWithFrame:(CGRect)frame identifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

/**
 更新标识符

 @param identifier 标识符
 */
- (void)updateIdentifier:(NSString *)identifier;

/**
 刷新源数据
 */
- (void)reloadListData;

/**
 设置选中样式

 @param isSelected 是否选中
 @param indexPath 设置的选项的位置
 @param clean   是否清除当前分区的其他选项选中状态
 */
- (void)setSelectedState:(BOOL)isSelected forIndexPath:(NSIndexPath *)indexPath cleanOtherItemCurrentSection:(BOOL)clean;

#pragma mark - 禁用的方法 ---

/**
 初始化方法请使用 initWithFrame:identifier:方法初始化
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 初始化方法请使用 initWithFrame:identifier:方法初始化
 */
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/**
 初始化方法请使用 initWithFrame:identifier:方法初始化
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end


#pragma mark - 菜单标题cell -----
@interface ListMenuViewCell : UITableViewCell

/**
 TitleLabel
 */
@property (readonly, strong, nonatomic) UILabel *titleLabel;

/**
 是否显示分割线
 */
@property (assign, nonatomic) BOOL isShowSeparator;

@end
NS_ASSUME_NONNULL_END
