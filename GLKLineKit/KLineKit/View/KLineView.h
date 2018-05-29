//
//  KlineView.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/4/28.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineViewProtocol.h"
#import "ChartDrawProtocol.h"
@class DataCenter,BaseDrawLogic,KLineDataLogic;

/* 重绘时的位置类型 */
typedef enum : NSUInteger {
    ReDrawTypeDefault = 1,      // 重绘并保留当前位置
    ReDrawTypeToTail,           // 重绘并回到尾部
    ReDrawTypeToHead,           // 重绘并回到头部
} ReDrawType;

NS_ASSUME_NONNULL_BEGIN
@interface KLineView : UIView

/**
 数据中心
 */
@property (readonly, weak, nonatomic) DataCenter *dataCenter;

/**
 数据逻辑处理类
 */
@property (readonly, strong, nonatomic) KLineDataLogic *dataLogic;

/**
 K线图的配置对象
 默认为KlineViewConfig
 如果要自定义，请使用initWithConfig:方法
 */
@property (readonly, strong, nonatomic) NSObject<KLineViewProtocol>*config;

/**
 当前的最值
 */
@property (readonly, assign, nonatomic) GLExtremeValue currentExtremeValue;

/**
 初始化方法

 @param frame 尺寸
 @param customConfig 自定义K线图的配置文件
 */
- (instancetype)initWithFrame:(CGRect)frame config:(NSObject<KLineViewProtocol>* _Nullable)customConfig;

/**
 将当前View的DataLogic更换为指定的DataLogic

 @param dataLogic 指定的dataLogic
 */
- (void)replaceDataLogicWithLogic:(KLineDataLogic *)dataLogic;

/**
 是否包含某个指定id的绘图算法

 @param identifier id
 @return 存在返回YES，不存在返回NO
 */
- (BOOL)containsDrawLogicWithIdentifier:(NSString * _Nullable)identifier;

/**
 添加绘图算法

 @param logic 需要添加的绘图算法
 @return 添加后的绘图算法
 */
- (NSArray <BaseDrawLogic *>* _Nullable)addDrawLogic:(BaseDrawLogic<ChartDrawProtocol>*)logic;

/**
 清除所有绘图算法
 
 @return 清除的算法个数
 */
- (NSInteger)removeAllDrawLogic;

/**
 移除某个绘图算法

 @param identifier 需要移除的绘图算法的标识符
 @return 移除以后的绘图算法集合
 */
- (NSArray <BaseDrawLogic *>* _Nullable)removeDrawLogicWithLogicId:(NSString *)identifier;

/**
 移除某个绘图算法
 
 @param logic 需要移除的绘图算法
 @return 移除以后的绘图算法集合
 */
- (NSArray <BaseDrawLogic *>* _Nullable)removeDrawLogicWithLogic:(BaseDrawLogic<ChartDrawProtocol>*)logic;

/**
 根据缩放比例绘制

 @param scale 缩放比例
 */
- (void)reDrawWithScale:(CGFloat)scale;

/**
 重新绘制
 缩放比例还是按照之前显示的比例
 @param drawType 绘制时采用的类型
 */
- (void)reDrawWithType:(ReDrawType)drawType;
@end
NS_ASSUME_NONNULL_END
