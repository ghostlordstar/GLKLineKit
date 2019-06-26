//
//  BaseDrawLogic.m
//  KLineDemo
//
//  Created by kk_ghostlord on 2018/5/2.
//  Copyright © 2018年 Ghostlrod. All rights reserved.
//

#import "BaseDrawLogic.h"

@implementation BaseDrawLogic

/**
 初始化方法
 
 @param rect 绘制的区域
 @param identifier 绘图算法的标识符
 @param graphType 所属的图形类型,默认为[GraphTypeMain]
 */
- (instancetype)initWithRect:(CGRect)rect drawLogicIdentifier:(NSString *)identifier graphType:(GraphType)graphType {
    if(self == [super init]) {
        if (identifier && [identifier isKindOfClass:[NSString class]] && identifier.length > 0) {
            _drawLogicIdentifier = identifier;
            _logicRect = rect;
            
            if(graphType < GraphTypeMain || graphType > GraphTypeFull) {
                _graphType = GraphTypeMain;
            }else {
                _graphType = graphType;
            }
        }
    }
    return self;
}

- (void)updateConfig:(NSObject<KLineViewProtocol> *)config NS_REQUIRES_SUPER {
    if (config) {
        _config = config;
    }
}

- (void)drawWithCGContext:(CGContextRef)ctx rect:(CGRect)rect indexPathForVisibleRange:(CGPoint)visibleRange scale:(CGFloat)scale otherArguments:(NSDictionary *)arguments {}

@end
