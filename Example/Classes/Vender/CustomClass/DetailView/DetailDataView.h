//
//  DetailDataView.h
//  GLKLineKit
//
//  Created by walker on 2018/5/29.
//  Copyright © 2018年 walker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailDataModel;
NS_ASSUME_NONNULL_BEGIN
@interface DetailDataView : UIView
/**
 height for row
 */
@property (assign, nonatomic) CGFloat rowHeight;

/**
 Text Color
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 text Font
 */
@property (strong, nonatomic) UIFont *textFont;

/**
 内边距
 */
@property (assign, nonatomic) UIEdgeInsets insets;

/**
 更新内容

 @param models 内容数组
 */
- (void)updateContentWithDetailModels:(NSArray <DetailDataModel *>*)models;

@end

#pragma mark - 展示数据模型 ---


/**
 ————————————————
 |name1    desc1|
 |name2    desc2|
 ————————————————
 */
@interface DetailDataModel : NSObject

/**
 name
 */
@property (copy, nonatomic) NSString *name;

/**
 desc
 */
@property (copy, nonatomic) NSString *desc;

/**
 便利构造器
 */
- (instancetype)initWithName:(NSString *)name desc:(NSString *)desc;
@end
NS_ASSUME_NONNULL_END

