//
//  BaseDrawLogic.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/2.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/**
 此类只是父类，不包含业务逻辑，不可使用
 需要使用此类的子类
 */
#import <Foundation/Foundation.h>
#import "ChartDrawProtocol.h"
#import "NSValue+GLExtremeValue.h"
#import "NSNumber+StringFormatter.h"
#import "GLKLineKitPublicEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseDrawLogic : NSObject <ChartDrawProtocol>

/**
当前绘图算法的标识符，用作增删改查的标识
 此处不安全，还需处理
*/
@property (copy, nonatomic) NSString *drawLogicIdentifier;

/* 绘制的区域 */
@property (assign, nonatomic) CGRect logicRect;

/* 绘图算法所属的图形类型 */
@property (readonly, assign, nonatomic) GraphType graphType;

/**
 配置类对象
 如果是自定义的配置类，一定要传，
 如果不传默认使用的是KLineViewConfig
 */
@property (readonly, strong, nonatomic) NSObject <KLineViewProtocol> *config;

/**
 初始化方法

 @param rect 绘制的区域
 @param identifier 绘图算法的标识符
 @param graphType 所属的图形类型,默认为[GraphTypeMain]
 */
- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType NS_DESIGNATED_INITIALIZER NS_REQUIRES_SUPER;

/**
 更新配置
 如果是自定义的配置类，一定要传，
 如果不传默认使用的是KLineViewConfig
 */
- (void)updateConfig:(NSObject<KLineViewProtocol> *)config NS_REQUIRES_SUPER;

/**
 禁用此初始化方法
 请使用 - initWithRect:drawLogicIdentifier:方法
 */
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
