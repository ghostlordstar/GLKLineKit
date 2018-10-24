//
//  DataCenter.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/4/28.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "DataCenter.h"
#import "KLineIndicatorLogic.h"
@interface DataCenter ()

/**
 KlineModelArray
 */
@property (readwrite, strong, nonatomic) NSMutableArray *klineModelArray;

/**
 代理集合
 */
@property (strong, nonatomic) NSPointerArray *delegateContainer;

/**
 IndicatorsData state
 */
@property (strong, nonatomic) NSMutableDictionary *indicatorsDataStateDict;

@end

@implementation DataCenter

#pragma mark - 单例相关 -----begin---
/*
 创建静态对象 防止外部访问
 */
static DataCenter *_center;
/**
 重写初始化方法
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_center == nil) {
            _center = [super allocWithZone:zone];
            _center.decimalsLimit = -1;
        }
    });
    return _center;
}

/**
 初始化单例
 
 @return 数据中心单例
 */
+ (instancetype)shareCenter
{
    return [[self alloc]init];
}

/**
 重写copyWithZone
 */
-(id)copyWithZone:(NSZone *)zone
{
    return _center;
}

/**
 重写mutableCopyWithZone
 */
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _center;
}

#pragma mark - 单例相关 ----- end ---

#pragma mark - 代理相关 ----- begin ---

/**
 添加代理
 
 @param delegate 遵循<DataCenterProtocol>协议的代理
 支持多代理模式，但是要记得移除，否则会造成多次调用
 */
- (void)addDelegate:(id<DataCenterProtocol>)delegate {
    if(delegate) {
        for (id tempDelegate in self.delegateContainer) {
            if ([tempDelegate isEqual:delegate]) {
                // 已经有了这个代理直接return
                return;
            }
        }
        // 将代理添加到弱引用容器中
        [self.delegateContainer addPointer:(__bridge void * _Nullable)(delegate)];
    }
    
    // 自动检测并移除失效的代理
    [self.delegateContainer compact];
}

/**
 移除代理
 
 @param delegate 遵循<DataCenterProtocol>协议的代理
 */
- (void)removeDelegate:(id<DataCenterProtocol>)delegate {
    
    if (delegate) {
        for (int a = 0 ; a < self.delegateContainer.count ; a ++) {
            
            id tempDelegate = [self.delegateContainer pointerAtIndex:a];
            
            if (tempDelegate && [tempDelegate isEqual:delegate]) {
                [self.delegateContainer removePointerAtIndex:a];
                break;
            }
        }
    }
    // 自动检测并移除失效的代理
    [self.delegateContainer compact];
}


/**
 代理弱引用容器的懒加载
 */
- (NSPointerArray *)delegateContainer {
    
    if(!_delegateContainer) {
        _delegateContainer = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegateContainer;
}
#pragma mark - 代理相关 ----- end ---

/**
 清空数据
 */
- (void)cleanData {
    
    self.decimalsLimit = -1;
    [self.klineModelArray removeAllObjects];
    
    // 通知所有代理
    for (id delegate in self.delegateContainer) {
        if (delegate && [delegate respondsToSelector:@selector(dataDidCleanAtDataCenter:)]) {
            [delegate dataDidCleanAtDataCenter:self];
        }
    }
}

/**
 刷新数据
 
 @param dataArray 刷新数据
 */
- (void)reloadDataWithArray:(NSArray *)dataArray {
    
    self.decimalsLimit = -1;
    
    [self.klineModelArray removeAllObjects];
    
    if (dataArray && dataArray.count >= 1) {
        
        [self.klineModelArray addObjectsFromArray:dataArray];
        
        // 重新计算所有指标
        [self p_prepareAllDataFromIndex:0];
        
        // 通知所有代理
        for (id delegate in self.delegateContainer) {
            if (delegate && [delegate respondsToSelector:@selector(dataCenter:didReload:)]) {
                [delegate dataCenter:self didReload:self.klineModelArray];
            }
        }
    }
}

/**
 追加数据
 
 @param moreDataArray 追加的数据
 */
- (void)addMoreDataWithArray:(NSArray *)moreDataArray {
    
    if (moreDataArray && moreDataArray.count >= 1) {
        NSInteger tempIndex = ([self.klineModelArray count] - 1);
        [self.klineModelArray addObjectsFromArray:moreDataArray];
        
        // 计算追加后的数据
        [self p_prepareAllDataFromIndex:tempIndex];
        
        // 通知所有代理
        for (id delegate in self.delegateContainer) {
            if (delegate && [delegate respondsToSelector:@selector(dataCenter:didAddNewDataInTail:)]) {
                [delegate dataCenter:self didAddNewDataInTail:self.klineModelArray];
            }
        }
    }
}


/**
 追加数据
 
 @param moreDataArray 需要追加的数据
 @param mergeCheckBlock 对追加的数据进行去重合并处理的block
 */
- (void)addMoreDataWithArray:(NSArray * _Nullable)moreDataArray isMergeModel:(IsMergeModelBlock)mergeCheckBlock {
//    NSLog(@"kline123456789----3");
    if (!mergeCheckBlock) {
        
        [self addMoreDataWithArray:moreDataArray];
    }else {
        if(moreDataArray.count >= 1) {
            KLineModel *lastModel = [self.klineModelArray lastObject];
            NSInteger prepareIndex = 0;
            NSInteger lastIndex = -1;
            if (lastModel) {
                lastIndex = lastModel.index;
                prepareIndex = lastModel.index;
            }
            
            // 添加的数据超过两个，需要对要添加的数据进行合并处理
            for (NSInteger a = 0; a < moreDataArray.count; a ++) {
                BOOL isSame = NO;
                KLineModel *tempModel = moreDataArray[a];
                if (lastModel) {
                    isSame = mergeCheckBlock(lastModel,tempModel);
                }
                
                if (!isSame) {
                    // 不合并
                    tempModel.index = lastIndex + 1;
                    [self.klineModelArray addObject:tempModel];
                }else {
                    // 合并
                    tempModel.index = lastIndex;
                    [self.klineModelArray replaceObjectAtIndex:lastIndex withObject:tempModel];
                }
                
                lastIndex = tempModel.index;
                lastModel = tempModel;
            }
            
            // 计算追加数据的指标
            [self p_prepareAllDataFromIndex:prepareIndex];
            
            // 通知所有代理
            for (id delegate in self.delegateContainer) {
                if (delegate && [delegate respondsToSelector:@selector(dataCenter:didAddNewDataInTail:)]) {
                    [delegate dataCenter:self didAddNewDataInTail:self.klineModelArray];
                }
            }
        }
    }
}


/**
 根据模型得到当前所处的位置
 
 @param model 模型
 */
- (NSInteger)getIndexWithKlineModel:(KLineModel *)model {
    
    __block NSInteger index = -1;
    
    if (self.klineModelArray.count >= 1) {
        [self.klineModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KLineModel *tempModel = (KLineModel *)obj;
            if(tempModel.stamp == model.stamp) {
                index = idx;
                *stop = YES;
            }
        }];
    }
    return index;
}

/**
 某个类型指标数据是否已经准备好
 
 @param dataType 指标数据类型
 @return 准备好返回YES，未准备好返回NO
 */
- (BOOL)isPrepareForDataType:(IndicatorsDataType)dataType {
    
    BOOL isPrepare = NO;
    
    isPrepare = [[self.indicatorsDataStateDict objectForKey:@(dataType)] boolValue];
    
    return isPrepare;
}

/**
 准备指定指标类型数据
 
 @param dataType 数据类型
 @param index 开始的下标，一直到结束
 */
- (void)prepareDataWithType:(IndicatorsDataType)dataType fromIndex:(NSUInteger)index {
    
    switch (dataType) {
        case IndicatorsDataTypeNone:
        {
            // 无处理
        }
            break;
        case IndicatorsDataTypeMA:
        {
            // 计算MA
            [KLineIndicatorLogic prepareDataForMAFromIndex:index];
            [self.indicatorsDataStateDict setObject:@(YES) forKey:@(dataType)];

        }
            break;
            
        case IndicatorsDataTypeVolMA:
        {
            // 计算Vol MA
            [KLineIndicatorLogic prepareDataForVolMAFromIndex:index];
            [self.indicatorsDataStateDict setObject:@(YES) forKey:@(dataType)];

        }
            break;
            
        case IndicatorsDataTypeBOLL:
        {
            // 计算BOLL
            [KLineIndicatorLogic prepareDataForBOLLFromIndex:index];
            [self.indicatorsDataStateDict setObject:@(YES) forKey:@(dataType)];

        }
            break;
            
        case IndicatorsDataTypeMACD:
        {
            // 计算MACD
            [KLineIndicatorLogic prepareDataForMACDFromIndex:index];
            [self.indicatorsDataStateDict setObject:@(YES) forKey:@(dataType)];

        }
            break;
            
        case IndicatorsDataTypeKDJ:
        {
            // 计算KDJ
            [KLineIndicatorLogic prepareDataForKDJFromIndex:index];
            [self.indicatorsDataStateDict setObject:@(YES) forKey:@(dataType)];

        }
            break;
            
        case IndicatorsDataTypeRSI:
        {
            // 计算RSI
            [KLineIndicatorLogic prepareDataForRSIFromIndex:index];
            [self.indicatorsDataStateDict setObject:@(YES) forKey:@(dataType)];

        }
            break;
            
        default:{}
            break;
    }
    
}


/**
 将某种指标数据的准备状态取消
 
 @param dataType 指标数据状态
 */
- (void)unPrepareIndicatorsDataStateWithDataType:(IndicatorsDataType)dataType {
    
    if(dataType) {
        switch (dataType) {
            case IndicatorsDataTypeMA:
            {
                [self.indicatorsDataStateDict setObject:@(NO) forKey:@(IndicatorsDataTypeMA)];
            }
                break;
                
            case IndicatorsDataTypeVolMA:
            {
                [self.indicatorsDataStateDict setObject:@(NO) forKey:@(IndicatorsDataTypeVolMA)];
            }
                break;
                
            case IndicatorsDataTypeBOLL:
            {
                [self.indicatorsDataStateDict setObject:@(NO) forKey:@(IndicatorsDataTypeBOLL)];
            }
                break;
                
            case IndicatorsDataTypeMACD:
            {
                [self.indicatorsDataStateDict setObject:@(NO) forKey:@(IndicatorsDataTypeMACD)];
                
            }
                break;
            case IndicatorsDataTypeKDJ:
            {
                [self.indicatorsDataStateDict setObject:@(NO) forKey:@(IndicatorsDataTypeKDJ)];
                
            }
                break;
            case IndicatorsDataTypeRSI:
            {
                [self.indicatorsDataStateDict setObject:@(NO) forKey:@(IndicatorsDataTypeRSI)];
                
            }
                break;

            default:
                break;
        }
    }
}

/**
 取消所有指标类型数据的准备状态
 */
- (void)unPrepareAllIndicatorsDataState {
    
    for (NSNumber *tempKey in self.indicatorsDataStateDict) {
        [self.indicatorsDataStateDict setObject:@(NO) forKey:tempKey];
    }
}

#pragma mark - 私有方法 ---

/**
 分段准备所有需要准备的指标数据
 
 @param index 开始的下标
 */
- (void)p_prepareAllDataFromIndex:(NSUInteger)index {
    // 找出所有需要准备的指标数据，并进行追加计算
    
    for (NSNumber *tempKey in [self.indicatorsDataStateDict copy]) {
        if ([[self.indicatorsDataStateDict objectForKey:tempKey] boolValue]) {
            [self prepareDataWithType:[tempKey integerValue] fromIndex:index];
        }
    }
}

#pragma mark - 懒加载 ---

- (NSMutableArray *)klineModelArray {
    if (!_klineModelArray) {
        _klineModelArray = @[].mutableCopy;
    }
    return _klineModelArray;
}

- (NSMutableDictionary *)indicatorsDataStateDict {
    if (!_indicatorsDataStateDict) {
        _indicatorsDataStateDict = @{
                                     @(IndicatorsDataTypeMA):@(NO),
                                     @(IndicatorsDataTypeBOLL):@(NO),
                                     @(IndicatorsDataTypeVolMA):@(NO),
                                     @(IndicatorsDataTypeMACD):@(NO),
                                     @(IndicatorsDataTypeKDJ):@(NO),
                                     @(IndicatorsDataTypeRSI):@(NO)
                                     }.mutableCopy;
    }
    return _indicatorsDataStateDict;
}

@end
