//
//  SimpleKLineVolView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "SimpleKLineVolView.h"
@interface SimpleKLineVolView ()<KLineDataLogicProtocol>
/** mainViewConfig */
@property (strong, nonatomic) KLineViewConfig *mainViewConfig;

/** VolViewConfig */
@property (strong, nonatomic) KLineVolViewConfig *volViewConfig;

/** 当前的主图样式 */
@property (assign, nonatomic) KLineMainViewType mainViewType;

/** 当前显示的区域 */
@property (assign, nonatomic) CGPoint currentVisibleRange;

/** 每个item的宽度 */
@property (assign, nonatomic) CGFloat perItemWidth;

/** 时间绘制的点的集合 */
@property (strong, nonatomic) NSMutableArray *timePointArray;

@end

@implementation SimpleKLineVolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self p_initialize];
        
        [self p_setUpUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if ([DataCenter shareCenter].klineModelArray.count <= 0) {
        return;
    }
    
    // TODO:绘制时间
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 开始和结束的K线下标
    NSInteger beginItemIndex = floor(self.currentVisibleRange.x);
    NSInteger endItemIndex = ceil(self.currentVisibleRange.y);
    
    // 每个时间之间的间隔
    NSInteger timeGapCount = (endItemIndex - beginItemIndex) / 4;
    
    if (beginItemIndex < 0) {
        beginItemIndex = 0;
    }
    // 修正最后一个元素下标，防止数组越界
    if (endItemIndex >= [DataCenter shareCenter].klineModelArray.count) {
        endItemIndex = [DataCenter shareCenter].klineModelArray.count - 1;
    }
    
    [self.timePointArray removeAllObjects];
    // 要绘制的时间的下标
    NSInteger drawIndex = endItemIndex;
    // 要绘制的时间区域的中心X坐标
    CGFloat drawCenterX = rect.size.width - ((self.currentVisibleRange.y - drawIndex) * self.perItemWidth);
    // point.x:表示要绘制的时间的下标，y:表示这个时间绘制区域的中心X
    CGPoint drawPoint = CGPointMake(drawIndex, drawCenterX);
    
    [self.timePointArray addObject:@(drawPoint)];
    
    while (drawCenterX >= 0 && drawIndex > 0) {
        drawIndex -= timeGapCount;
        if(drawIndex < 0) {
            drawCenterX -= self.perItemWidth * drawIndex;
            drawIndex = 0;
        }else {
            drawCenterX -= self.perItemWidth * timeGapCount;
        }
        
        drawPoint = CGPointMake(drawIndex, drawCenterX);
        [self.timePointArray addObject:@(drawPoint)];
    }
    // 绘制时间
    [self p_drawTimeWithContent:ctx];
}


/**
 绘制时间

 @param ctx 绘图上下文
 */
- (void)p_drawTimeWithContent:(CGContextRef)ctx {
    CGFloat originY = CGRectGetMaxY(self.kLineMainView.frame);
    CGFloat width = 50.0f;
    CGFloat height = 20.0f;
    
    for (NSInteger a = 0; a < self.timePointArray.count ; a ++) {
        CGPoint tempPoint = [self.timePointArray[a] CGPointValue];
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[(NSInteger)tempPoint.x];
        NSString *timeString = [NSString gl_convertTimeStamp:tempModel.stamp toFormatter:@"HH:mm"];
        CGRect textRect = CGRectMake(tempPoint.y - (width / 2.0), originY, width, height);
        NSLog(@"timeString = %@",timeString);
        [self p_drawText:timeString content:ctx textRect:textRect];
    }
}

/**
 绘制文字
 
 @param ctx 上下文
 @param rect 文字绘制区域
 */
- (void)p_drawText:(NSString *)text content:(CGContextRef)ctx textRect:(CGRect)rect {
    
    // 居中
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    // 属性：字体，颜色，居中
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],       // 字体
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],   // 字体颜色
                                 NSParagraphStyleAttributeName:style,   // 段落样式
                                 };;
    
    // 计算字体的大小
    CGSize textSize = [text sizeWithAttributes:attributes];
    
    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);
    
    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(rect.origin.x, originY , textSize.width , textSize.height );
    
    // 绘制字体
    [text drawInRect:textRect withAttributes:attributes];
}

#pragma mark - 初始化等方法 -------

- (void)p_initialize {
    
    self.backgroundColor = [UIColor grayColor];
    // 默认显示K线样式
    self.mainViewType = KLineMainViewTypeKLine;
    // 添加代理
    [self.kLineMainView.dataLogic addDelegate:self];
}

- (void)p_setUpUI {
    
    [self addSubview:self.kLineMainView];
    [self addSubview:self.volView];
    
    [self p_layout];
}

- (void)p_layout {
    
    
    
}

#pragma mark - KLineDataLogic Delegate ----
// 可见区域改变
- (void)visibleRangeDidChanged:(CGPoint)visibleRange scale:(CGFloat)scale {
    // 保存可见区域
    self.currentVisibleRange = visibleRange;
    // 计算当前的每个元素的宽度
    self.perItemWidth = ([self.kLineMainView.config defaultEntityLineWidth] + [self.kLineMainView.config klineGap]) * scale;
    // 重绘时间
    [self setNeedsDisplay];
}

// 十字线是否展示
- (void)reticleIsShow:(BOOL)isShow {
    
    
    
}

/**
 KLineView 被点击的回调方法(十字线显示)
 
 @param view 被点击的View
 @param point point 点击的点
 @param index index 当前触点所在item的下标
 */
- (void)klineView:(KLineView *)view didTapAtPoint:(CGPoint)point selectedItemIndex:(NSInteger)index {
    
    
}

/**
 KLineView 上触点移动的回调方法(十字线移动)
 
 @param view 触点起始的View
 @param point point 点击的点
 @param index index 当前触点所在item的下标
 */
- (void)klineView:(KLineView *)view didMoveToPoint:(CGPoint)point selectedItemIndex:(NSInteger)index {
    
}

/**
 KLineView 上的触点移除的回调方法(十字线消失)
 
 @param view 触点当前所在的View
 @param point 触点相对于当前view的位置
 @param index 触点所在item的下标
 */
- (void)klineView:(KLineView *)view didRemoveAtPoint:(CGPoint)point selectedItemIndex:(NSInteger)index {
    
}

#pragma mark - 赋值或set方法 ----

#pragma mark - 公共方法 -----

/**
 切换主图样式
 */
- (void)switchKLineMainViewToType:(KLineMainViewType)type {
    
    if (type) {
        switch (type) {
                
            case KLineMainViewTypeKLine:
            {// 主图切为分时蜡烛图
                
                // 移除之前的绘图算法
                [self.kLineMainView removeDrawLogicWithLogicId:@"main_time"];
                [self.kLineMainView removeDrawLogicWithLogicId:@"main_time_ma_30"];
                
                // 添加蜡烛图绘图算法
                [self.kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithDrawLogicIdentifier:@"k_line"]];
                [self.kLineMainView addDrawLogic:[[KLineMADrawLogic alloc] initWithDrawLogicIdentifier:@"main_ma_5_10_30"]];
            }
                break;
                
                
            case KLineMainViewTypeTimeLine:
            {  // 主图样式切换为分时图
                
                // 移除之前的绘图算法
                [self.kLineMainView removeDrawLogicWithLogicId:@"k_line"];
                [self.kLineMainView removeDrawLogicWithLogicId:@"main_ma_5_10_30"];
                
                // 添加分时绘图算法
                [self.kLineMainView addDrawLogic:[[KLineTimeDrawLogic alloc] initWithDrawLogicIdentifier:@"main_time"]];
                KLineMADrawLogic *timeMA = [[KLineMADrawLogic alloc] initWithDrawLogicIdentifier:@"main_time_ma_30"];
                [timeMA setMa5Hiden:YES];
                [timeMA setMa10Hiden:YES];
                [self.kLineMainView addDrawLogic:timeMA];
                
            }
                break;
                
                
                
            default:
                break;
        }
    }
    
}

#pragma mark - 私有方法 -------


#pragma mark - 懒加载 ---------

- (KLineView *)kLineMainView {
    if (!_kLineMainView) {
        _kLineMainView = [[KLineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - 20.0f) * 7.0/10.0) config:self.mainViewConfig];
        _kLineMainView.backgroundColor = [UIColor blackColor];
        // 添加绘图算法
        [_kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithDrawLogicIdentifier:@"k_line"]];
        [_kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"main_bg"]];
        [_kLineMainView addDrawLogic:[[KLineMADrawLogic alloc] initWithDrawLogicIdentifier:@"main_ma_5_10_30"]];
    }
    return _kLineMainView;
}

- (KLineView *)volView {
    if (!_volView) {
        _volView = [[KLineView alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(self.kLineMainView.frame) + 20.0f), self.frame.size.width, ((self.frame.size.height - 20.0f) * 3.0/10.0)) config:self.volViewConfig];
        _volView.backgroundColor = [UIColor blackColor];
        // 替换逻辑处理对象为主图逻辑处理对象
        [_volView replaceDataLogicWithLogic:self.kLineMainView.dataLogic];
        
        // 添加绘图算法
        [_volView addDrawLogic:[[KLineVolDrawLogic alloc] initWithDrawLogicIdentifier:@"vol"]];
        [_volView addDrawLogic:[[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"vol_bg"]];
        [_volView addDrawLogic:[[KLineVolMADrawLogic alloc] initWithDrawLogicIdentifier:@"vol_ma"]];
    }
    return _volView;
}

- (KLineViewConfig *)mainViewConfig {
    if (!_mainViewConfig) {
        _mainViewConfig = [[KLineViewConfig alloc] init];
    }
    return _mainViewConfig;
}

- (KLineVolViewConfig *)volViewConfig {
    if (!_volViewConfig) {
        _volViewConfig = [[KLineVolViewConfig alloc] init];
    }
    return _volViewConfig;
}

- (DataCenter *)dataCenter {
    
    if (!_dataCenter) {
        _dataCenter = [self.kLineMainView dataCenter];
    }
    return _dataCenter;
}

- (NSMutableArray *)timePointArray {
    if (!_timePointArray) {
        _timePointArray = [[NSMutableArray alloc] init];
    }
    return _timePointArray;
}

@end
