//
//  DataCenterProtocol.h
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/10.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

/* 数据中心的协议 */

#import <Foundation/Foundation.h>
@class DataCenter;
@protocol DataCenterProtocol <NSObject>

/**
 数据已经刷新

 @param dataCenter 数据中心
 @param modelArray 刷新后的数据
 */
- (void)dataCenter:(DataCenter *)dataCenter didReload:(NSArray *)modelArray;

/**
 数据已经被清空
 
 @param dataCenter 数据中心
 */
- (void)dataDidCleanAtDataCenter:(DataCenter *)dataCenter;

/**
 在尾部添加了最新数据

 @param dataCenter 数据中心
 @param modelArray 添加后的数据
 */
- (void)dataCenter:(DataCenter *)dataCenter didAddNewDataInTail:(NSArray *)modelArray;

/**
 在头部添加了数据
 
 @param dataCenter 数据中心
 @param modelArray 添加后的数据
 */
- (void)dataCenter:(DataCenter *)dataCenter didAddNewDataInHead:(NSArray *)modelArray;
@end
