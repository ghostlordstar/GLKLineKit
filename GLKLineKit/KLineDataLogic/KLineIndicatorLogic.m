//
//  KLineIndicatorLogic.m
//  KLineDemo
//
//  Created by walker on 2018/5/22.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "KLineIndicatorLogic.h"
#import "DataCenter.h"
@implementation KLineIndicatorLogic

#pragma mark - MA(5,10,30) ---

/**
 分段计算MA数据
 MA(5,10,30) 计算方法
 */
+ (void)prepareDataForMAFromIndex:(NSUInteger)index {
    // MA准备数据方法
    if (index >= ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if ([DataCenter shareCenter].klineModelArray.count >= 5) {
        
        for (NSInteger a = index; a < [DataCenter shareCenter].klineModelArray.count; a ++) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            if (a >= (5 - 1)) {
                tempModel.ma5 = [self p_averagePriceWithCount:5 endIndex:a];
            }
            
            if (a >= (10 - 1)) {
                tempModel.ma10 = [self p_averagePriceWithCount:10 endIndex:a];
            }
            
            if (a >= (30 - 1)) {
                tempModel.ma30 = [self p_averagePriceWithCount:30 endIndex:a];
            }
        }
    }
}


/**
 计算平均值
 
 @param count 平均数的个数
 @param index 计算平均数结束的下标
 */
+ (double)p_averagePriceWithCount:(NSInteger)count endIndex:(NSInteger)index {
    double result = 0.0f;
    
    if (index < (count - 1)) {
        return result;
    }
    
    double sum = 0.0f;
    for (NSInteger a = index; a > (index - count) ; a --) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        sum += [tempModel close];
    }
    
    result = sum / (double)count;
    return result;
}

#pragma mark - VOLMA(5,10) ---
/**
 准备VOL MA数据
 
 @param index index
 */
+ (void)prepareDataForVolMAFromIndex:(NSInteger)index {
    
    // MA准备数据方法
    if (index >= ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if ([DataCenter shareCenter].klineModelArray.count >= 5) {
        
        for (NSInteger a = index; a < [DataCenter shareCenter].klineModelArray.count; a ++) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            if (a >= (5 - 1)) {
                tempModel.volMa5 = [self p_averageVolumeWithCount:5 endIndex:a];
            }
            
            if (a >= (10 - 1)) {
                tempModel.volMa10 = [self p_averageVolumeWithCount:10 endIndex:a];
            }
        }
    }
}

/**
 成交量平均值算法
 
 @param count 平均数的个数
 @param index 结束时的下标
 */
+ (double)p_averageVolumeWithCount:(NSInteger)count endIndex:(NSInteger)index {
    
    double result = 0.0f;
    
    if (index < (count - 1)) {
        return result;
    }
    
    double sum = 0.0f;
    for (NSInteger a = index; a > (index - count) ; a --) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        sum += [tempModel volume];
    }
    
    result = sum / (double)count;
    return result;
}

#pragma mark - BOLL(20,2) ---

/**
 BOLL数据准备方法
 
 @param index 开始计算的下标
 */
+ (void)prepareDataForBOLLFromIndex:(NSInteger)index {
    // BOLL准备方法
    if (index >= ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if ([DataCenter shareCenter].klineModelArray.count >= 20) {
        
        for (NSInteger a = index; a < [DataCenter shareCenter].klineModelArray.count; a ++) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            if (a >= (20 - 1)) {
                tempModel.ma20 = [self p_averagePriceWithCount:20 endIndex:a];
                
                tempModel.boll_up = tempModel.ma20 + (2.0 * [self p_std20WithCount:20 endIndex:a]);
                tempModel.boll_low = tempModel.ma20 - (2.0 * [self p_std20WithCount:20 endIndex:a]);
            }
        }
    }
}


/**
 std(close , 20)
 
 @param count 求和的个数
 @param index 结束的index
 @return 计算后的std(close , 20)
 */
+ (double)p_std20WithCount:(NSInteger)count endIndex:(NSInteger)index {
    double result = 0.0f;
    
    if (index < (count - 1)) {
        return result;
    }
    
    double sum = 0.0f;
    double ma20 = 0.0f;
    for (NSInteger a = index; a > (index - count) ; a --) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        if (!ma20) {
            ma20 = tempModel.ma20;
        }
        sum += pow(([tempModel close] - ma20),2);
    }
    // 开平方
    result = sqrt((sum / (double)count));
    
    return result;
}

#pragma mark - MACD(12,26,9) -----

/**
 MACD数据准备方法
 
 @param index 开始计算的下标
 */
+ (void)prepareDataForMACDFromIndex:(NSInteger)index {
    
    if (index >= ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if ([DataCenter shareCenter].klineModelArray.count >= 1) {
        
        for (NSInteger a = index; a < [DataCenter shareCenter].klineModelArray.count; a ++) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            // 计算EMA12,EMA26
            [self p_expmaWithIndex:a];
            // DIF
            tempModel.dif = tempModel.ema12 - tempModel.ema26;
            // DEA
            [self p_deaWithArgu:9 endIndex:a];
            // MACD柱线
            tempModel.macd = 2.0 * (tempModel.dif - tempModel.dea);
        }
    }
}


/**
 计算EMA的算法
 
 @param index 需要计算的下标
 */
+ (void)p_expmaWithIndex:(NSInteger)index {
    
    KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[index];
    
    if (index == 0) {
        
        // 第一日的ema12为收盘价
        tempModel.ema12 = tempModel.close;
        tempModel.ema26 = tempModel.close;
        
    }else if(!tempModel.ema12 || !tempModel.ema26) {
        
        KLineModel *lastModel = [DataCenter shareCenter].klineModelArray[index - 1];
        
        if (lastModel.ema12 && lastModel.ema26) {
            tempModel.ema12 = (2.0/13.0) * (tempModel.close - lastModel.ema12) + lastModel.ema12;
            tempModel.ema26 = (2.0/27.0) * (tempModel.close - lastModel.ema26) + lastModel.ema26;
            
        }else {
            
            [self p_expmaWithIndex:index - 1];
            
            tempModel.ema12 = (2.0/13.0) * (tempModel.close - lastModel.ema12) + lastModel.ema12;
            tempModel.ema26 = (2.0/27.0) * (tempModel.close - lastModel.ema26) + lastModel.ema26;
        }
    }
}


/**
 DIF的EMA(DEA)
 
 @param argu 计算平均值的平滑参数
 @param index 结束时的index
 */
+ (void)p_deaWithArgu:(NSInteger)argu endIndex:(NSInteger)index {
    
    KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[index];
    
    if (index == 0) {
        
        // 第一日的dea为0
        tempModel.dea = 0.0f;
    }else {
        
        KLineModel *lastModel = [DataCenter shareCenter].klineModelArray[index - 1];
        
        if (lastModel.dea) {
            tempModel.dea = lastModel.dea * (8.0 / 10.0) + tempModel.dif * (2.0 / 10.0);
        }else {
            
            [self p_deaWithArgu:argu endIndex:(index - 1)];
            tempModel.dea = lastModel.dea * (8.0 / 10.0) + tempModel.dif * (2.0 / 10.0);
        }
    }
}

#pragma mark - KDJ(9,3,3) 数据计算 ----
/**
 KDJ数据准备方法
 
 @param index 结束的下标
 */
+ (void)prepareDataForKDJFromIndex:(NSInteger)index {
    
    if (index > ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if ([DataCenter shareCenter].klineModelArray.count >= 1) {
        for (NSInteger a = index; a < [DataCenter shareCenter].klineModelArray.count ; a ++) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            
            if (a == 0) {
                tempModel.k = 50.0f;
                tempModel.d = 50.0f;
            }else {
                tempModel.rsv9 = [self p_rsv9WithEndIndex:a];
                [self p_K_D_WithIndex:a];
            }
            
            tempModel.j = (3.0 * tempModel.k) - (2.0 * tempModel.d);
        }
    }
}

/**
 计算RSV
 
 @param endindex 结束的下标
 @return 计算后的RSV9
 */
+ (double)p_rsv9WithEndIndex:(NSInteger)endindex {
    double result = 0.0f;
    double low9 = MAXFLOAT;
    double high9 = - MAXFLOAT;
    double close = 0.0f;
    
    NSInteger startIndex = endindex - (9 - 1);
    if (startIndex < 0) {
        startIndex = 0;
    }
    
    for (NSInteger a = endindex; a >= startIndex; a --) {
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
        
        if (tempModel.low < low9) {
            low9 = tempModel.low;
        }
        
        if (tempModel.high > high9) {
            high9 = tempModel.high;
        }
        
        if (a == endindex) {
            close = tempModel.close;
        }
    }
    
    result = (close - low9) / (high9 - low9) * 100.0;
    
    return isnan(result) ? 0 : result;
}


/**
 计算K值和D值
 
 @param index 需要计算的模型的下标
 */
+ (void)p_K_D_WithIndex:(NSInteger)index {
    
    KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[index];
    KLineModel *lastModel = [DataCenter shareCenter].klineModelArray[index - 1];
    
    tempModel.k = ((2.0 * lastModel.k) + tempModel.rsv9) / 3.0;
    tempModel.d = ((2.0 * lastModel.d) + tempModel.k) / 3.0;
}

#pragma mark - RSI(6,12,24) 数据计算 ----

/**
 RSI数据准备方法
 
 @param index 开始的下标
 */
+ (void)prepareDataForRSIFromIndex:(NSInteger)index {
    
    // MA准备数据方法
    if (index >= ([DataCenter shareCenter].klineModelArray.count - 1)) {
        index = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    if ([DataCenter shareCenter].klineModelArray.count >= 5) {
        
        for (NSInteger a = index; a < [DataCenter shareCenter].klineModelArray.count; a ++) {
            KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[a];
            if(a >= 1) {
                // 计算RS
                [self p_rsAtIndex:a];
                // 计算RSI
                tempModel.rsi6 = 100.0 - (100.0 / (1.0 + tempModel.up_avg_6 / tempModel.dn_avg_6));
                
                tempModel.rsi12 = 100.0 - (100.0 / (1.0 + tempModel.up_avg_12 / tempModel.dn_avg_12));
                
                tempModel.rsi24 = 100.0 - (100.0 / (1.0 + tempModel.up_avg_24 / tempModel.dn_avg_24));
                
            }
        }
    }
}

/**
 根据传入的参数计算RS
 
 @param atIndex 需要计算的下标
 */
+ (void)p_rsAtIndex:(NSInteger)atIndex {
    
    KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[atIndex];
    KLineModel *lastModel = [DataCenter shareCenter].klineModelArray[atIndex - 1];
    
    double diff = tempModel.close - lastModel.close;
    double up = fmax(0.0, diff);
    double dn = fabs(fmin(0.0, diff));
    
    if (atIndex == 1) {
        
        tempModel.up_avg_6 = up / 6.0;
        tempModel.up_avg_12 = up / 12.0;
        tempModel.up_avg_24 = up / 24.0;
        
        tempModel.dn_avg_6 = dn / 6.0;
        tempModel.dn_avg_12 = dn / 12.0;
        tempModel.dn_avg_24 = dn / 24.0;
        
    }else {
        
        tempModel.up_avg_6 = (up / 6.0) + ((lastModel.up_avg_6 * 5.0) / 6.0);
        tempModel.up_avg_12 = (up / 12.0) + ((lastModel.up_avg_12 * 11.0) / 12.0);
        tempModel.up_avg_24 = (up / 24.0) + ((lastModel.up_avg_24 * 23.0) / 24.0);
        
        tempModel.dn_avg_6 = (dn / 6.0) + ((lastModel.dn_avg_6 * 5.0) / 6.0);
        tempModel.dn_avg_12 = (dn / 12.0) + ((lastModel.dn_avg_12 * 11.0) / 12.0);
        tempModel.dn_avg_24 = (dn / 24.0) + ((lastModel.dn_avg_24 * 23.0) / 24.0);
        
    }
}

@end
