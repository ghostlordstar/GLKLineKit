//
//  KLineIndicatorLogic.h
//  KLineDemo
//
//  Created by walker on 2018/5/22.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/*
 指标数据准备计算逻辑类
 此部分逻辑是从DataCenter中独立出来的
 ♻️ 代表算法还有问题，需要调整
 ✅ 代表已经经过验证，一般没什么问题
 */
#import <Foundation/Foundation.h>

@interface KLineIndicatorLogic : NSObject

/**
 分段计算MA数据 (✅)
 MA(5,10,30) 计算方法
 */
+ (void)prepareDataForMAFromIndex:(NSUInteger)index;

/**
 准备VOL MA数据(5,10) (✅)
 
 @param index 计算开始的index
 */
+ (void)prepareDataForVolMAFromIndex:(NSInteger)index;

/**
 BOLL数据准备方法(20,2) (✅)
 
 @param index 计算开始的下标
 */
+ (void)prepareDataForBOLLFromIndex:(NSInteger)index;

/**
 MACD数据准备方法(12,26,9) (✅)

 @param index 计算开始的下标
 */
+ (void)prepareDataForMACDFromIndex:(NSInteger)index;

/**
 KDJ数据准备方法(9,3,3) (✅)
 
 @param index 计算开始的下标
 */
+ (void)prepareDataForKDJFromIndex:(NSInteger)index;

/**
 RSI数据准备方法 (6,12,24) (✅)

 @param index 计算开始的下标
 软件绘制平滑处理
 当日上涨平均数 = 前一日涨幅平均数*5/6 + 当日涨幅/6 （若某日下跌时，则当日涨幅记为0）
 
 当日下跌平均数 = 前一日跌幅平均数*5/6 + 当日跌幅/6 （若某日上涨时，则当日跌幅记为0)
 */
+ (void)prepareDataForRSIFromIndex:(NSInteger)index;

@end
