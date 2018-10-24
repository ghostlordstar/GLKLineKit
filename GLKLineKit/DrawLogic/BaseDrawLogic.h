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
NS_ASSUME_NONNULL_BEGIN
@interface BaseDrawLogic : NSObject <ChartDrawProtocol>

/**
当前绘图算法的标识符，用作增删改查的标识
 此处不安全，还需处理
*/
@property (copy, nonatomic) NSString *drawLogicIdentifier;

/**
 配置类对象
 如果是自定义的配置类，一定要传，
 如果不传默认使用的是KLineViewConfig
 */
@property (strong, nonatomic) NSObject <KLineViewProtocol> *config;

/**
 初始化方法

 @param identifier 绘图算法的标识符
 */
- (instancetype)initWithDrawLogicIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER NS_REQUIRES_SUPER;

/**
 禁用此初始化方法
 请使用 - initWithDrawLogicIdentifier:方法
 */
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
