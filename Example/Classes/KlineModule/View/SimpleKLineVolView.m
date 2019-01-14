//
//  SimpleKLineVolView.m
//  GLKLineKit
//
//  Created by walker on 2018/5/25.
//  Copyright © 2018年 walker. All rights reserved.
//

#import "SimpleKLineVolView.h"
#import "NSNumber+StringFormatter.h"
#import "DetailDataView.h"
#import "HorizontalView.h"
#import "VerticalView.h"
@interface SimpleKLineVolView ()<KLineDataLogicProtocol,DataCenterProtocol>
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

/**
 十字线的垂直文字显示视图
 */
@property (strong, nonatomic) VerticalView *verticalTextView;

/**
 十字线的竖线视图
 */
@property (strong, nonatomic) UIView *verticalLineView;

/**
 十字线的水平文字显示视图
 */
@property (strong, nonatomic) HorizontalView *horizontalTextView;

/**
 十字线的水平线视图
 */
@property (strong, nonatomic) UIView *horizontalLineView;

/**
 详情视图
 */
@property (strong, nonatomic) DetailDataView *detailView;
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
    
    // 每个时间之间的间隔K线条数
    NSInteger timeGapCount = (endItemIndex - beginItemIndex) / 4;
    // 每个时间之间的间隔宽度
    CGFloat timeGapWidth = self.kLineMainView.frame.size.width / 4.0;
    
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
    
    if(ceil(self.currentVisibleRange.y) <= ([DataCenter shareCenter].klineModelArray.count - 1) && self.currentVisibleRange.x > 0) {
        // 不能看到最后一根K线
        while (drawIndex >= beginItemIndex && drawIndex >= 0) {
            
            drawIndex = drawIndex - (timeGapWidth / self.perItemWidth);
            drawCenterX -= timeGapWidth;
            
            drawPoint = CGPointMake(drawIndex, drawCenterX);
            [self.timePointArray addObject:@(drawPoint)];
        }
        
    }else {
        // 可以看到最后一根K线
        
        while (drawCenterX > 0 && drawIndex > 0) {
            
            if(drawIndex <= timeGapCount) {
                drawCenterX -= self.perItemWidth * drawIndex;
                drawIndex = 0;
            }else {
                drawIndex -= timeGapCount;
                drawCenterX -= self.perItemWidth * timeGapCount;
            }
            
            drawPoint = CGPointMake(drawIndex, drawCenterX);
            [self.timePointArray addObject:@(drawPoint)];
        }
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
        if (tempPoint.x < 0) {
            tempPoint.x = 0;
        }else if(tempPoint.x > ([DataCenter shareCenter].klineModelArray.count - 1)) {
            tempPoint.x = [DataCenter shareCenter].klineModelArray.count - 1;
        }
        KLineModel *tempModel = [DataCenter shareCenter].klineModelArray[(NSInteger)tempPoint.x];
        NSString *timeString = [NSString gl_convertTimeStamp:(tempModel.stamp / 1000) toFormatter:@"HH:mm"];
        CGRect textRect = CGRectMake(tempPoint.y - (width / 2.0), originY, width, height);
        [self p_drawText:timeString content:ctx textRect:textRect];
    }
}

/**
 绘制文字
 
 @param ctx 上下文
 @param rect 文字绘制区域
 */
- (void)p_drawText:(NSString *)text content:(CGContextRef)ctx textRect:(CGRect)rect {
    // 左边坐标修正
    if (rect.origin.x < 0 && self.currentVisibleRange.y <= ([DataCenter shareCenter].klineModelArray.count - 1)) {
        rect.origin.x = 0;
    }
    
    
    // 居中
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    // 属性：字体，颜色，居中
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont kk_systemFontOfSize:12.0f],       // 字体
                                 NSForegroundColorAttributeName:KColorNormalText_666,   // 字体颜色
                                 NSParagraphStyleAttributeName:style,   // 段落样式
                                 };;
    
    // 计算字体的大小
    CGSize textSize = [text sizeWithAttributes:attributes];
    
    // 右边坐标修正
    if (CGRectGetMaxX(rect) > CGRectGetMaxX(self.kLineMainView.frame)) {
        rect.origin.x = self.frame.size.width - textSize.width;
    }
    
    
    CGFloat originY = rect.origin.y + ((rect.size.height - textSize.height) / 2.0);
    
    // 计算绘制字体的rect
    CGRect textRect = CGRectMake(rect.origin.x, originY , textSize.width , textSize.height );
    
    // 绘制字体
    [text drawInRect:textRect withAttributes:attributes];
}

#pragma mark - 初始化等方法 -------

- (void)p_initialize {
    
    self.backgroundColor = KColorBackGround;
    
    // 默认的一个K线的宽度为实体线的宽度与K线之间的间隙的和
    self.perItemWidth = ([self.kLineMainView.config defaultEntityLineWidth] + [self.kLineMainView.config klineGap]) * 1.0;
    // 默认的显示区域
    self.currentVisibleRange = self.kLineMainView.dataLogic.visibleRange;
    // 默认显示K线样式
    self.mainViewType = KLineMainViewTypeKLineWithMA;
    // 添加代理
    [self.kLineMainView.dataLogic addDelegate:self];
    [self.dataCenter addDelegate:self];
}

- (void)p_setUpUI {
    
    [self addSubview:self.kLineMainView];
    [self addSubview:self.volView];

    [self p_layout];
}

- (void)p_layout {
    
    [self.kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.7);
    }];
    
    [self.volView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.kLineMainView.mas_bottom).offset(20.0f);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
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
    
    if(isShow) {
        [self addSubview:self.detailView];
        [self addSubview:self.verticalLineView];
        [self addSubview:self.verticalTextView];
        [self addSubview:self.horizontalTextView];
        [self addSubview:self.horizontalLineView];
    }else {
        [self.detailView removeFromSuperview];
        [self.verticalLineView removeFromSuperview];
        [self.verticalTextView removeFromSuperview];
        [self.horizontalTextView removeFromSuperview];
        [self.horizontalLineView removeFromSuperview];
    }
}

/**
 KLineView 上触点移动的回调方法(十字线移动)
 
 @param view 触点起始的View
 @param point point 点击的点
 @param index index 当前触点所在item的下标
 */
- (void)klineView:(KLineView *)view didMoveToPoint:(CGPoint)point selectedItemIndex:(NSInteger)index {
    
    if (index >= [DataCenter shareCenter].klineModelArray.count || index < 0) {
        NSLog(@"下标有误，不能绘制");

        return;
    }
    // 垂直线 -----
    // 根据index获得选中item的中心X坐标
    CGFloat textCenterX = [self p_getCurrentSelectedItemCenterXWithIndex:index];
    
    if (textCenterX >= self.kLineMainView.frame.size.width) {
        textCenterX = self.kLineMainView.frame.size.width;
    }
    
    KLineModel *tempModel = [[DataCenter shareCenter].klineModelArray objectAtIndex:index];
    NSString *dateString = [NSString gl_convertTimeStamp:(tempModel.stamp / 1000) toFormatter:@"yy-MM-dd HH:mm"];
    [self.verticalTextView updateText:dateString textCenterX:textCenterX];
    self.verticalLineView.center = CGPointMake(textCenterX, (self.frame.size.height - 20.f) / 2.0f);
    
    // 水平线 -------
    CGPoint pointAtSuperView = point;
    if (view == self.volView) {
        pointAtSuperView = [view convertPoint:point toView:self];
    }
    
    CGFloat touchY = pointAtSuperView.y;
//    NSLog(@"point At superView = %@",NSStringFromCGPoint(pointAtSuperView));
    // 修正十字线水平文字边界
    if (touchY < 10.0f) {
        self.horizontalTextView.frame = CGRectMake(0, 0, self.frame.size.width, 20.0f);
        self.horizontalLineView.frame = CGRectMake(0, (touchY - 0.5f) >=0 ? (touchY - 0.5f) : 0, self.frame.size.width, 1.0);
        
    }else if(touchY > self.frame.size.height - 10.0f) {
        self.horizontalTextView.frame = CGRectMake(0, self.frame.size.height - 20.0f, self.frame.size.width, 20.0f);
        self.horizontalLineView.frame = CGRectMake(0, (touchY - 0.5f) <= (self.frame.size.height - 1.5f)? (touchY - 0.5f) : self.frame.size.height - 1.5f, self.frame.size.width, 1.0);
    }else if(touchY >= (CGRectGetMaxY(self.kLineMainView.frame) - 10.0f) && touchY <= CGRectGetMaxY(self.kLineMainView.frame)) {
        
        self.horizontalTextView.frame = CGRectMake(0, CGRectGetMaxY(self.kLineMainView.frame) - 20.0f, self.frame.size.width, 20.0f);
        self.horizontalLineView.frame = CGRectMake(0, (touchY - 0.5f) >=0 ? (touchY - 0.5f) : 0, self.frame.size.width, 1.0);
        
    }else if(touchY <= (CGRectGetMinY(self.volView.frame) + 10.0f) && touchY >= CGRectGetMinY(self.volView.frame)) {
        self.horizontalTextView.frame = CGRectMake(0, CGRectGetMinY(self.volView.frame), self.frame.size.width, 20.0f);
        self.horizontalLineView.frame = CGRectMake(0, (touchY - 0.5f) >=0 ? (touchY - 0.5f) : 0, self.frame.size.width, 1.0);
        
    }else {
        if (!(touchY > CGRectGetMaxY(self.kLineMainView.frame) && touchY < CGRectGetMinY(self.volView.frame))) {
            self.horizontalTextView.frame = CGRectMake(0, touchY - 10.0f, self.frame.size.width, 20.0f);
            self.horizontalLineView.frame = CGRectMake(0, (touchY - 0.5f) >=0 ? (touchY - 0.5f) : 0, self.frame.size.width, 1.0);
            
        }
    }
    
    if (touchY <= CGRectGetMaxY(self.kLineMainView.frame) && touchY >= 0) {
        
        double currentNum = (self.kLineMainView.currentExtremeValue.maxValue - self.kLineMainView.currentExtremeValue.minValue) * (1.0 - (touchY - [self.kLineMainView.config insetsOfKlineView].top) / (CGRectGetHeight(self.kLineMainView.frame) - ([self.kLineMainView.config insetsOfKlineView].top + [self.kLineMainView.config insetsOfKlineView].bottom))) + self.kLineMainView.currentExtremeValue.minValue;
        
        if (currentNum < self.kLineMainView.currentExtremeValue.minValue) {
            currentNum = self.kLineMainView.currentExtremeValue.minValue;
        }else if(currentNum > self.kLineMainView.currentExtremeValue.maxValue) {
            currentNum = self.kLineMainView.currentExtremeValue.maxValue;
        }
        
        NSString *currentNumString = [@(currentNum) gl_numberToStringWithDecimalsLimit:[DataCenter shareCenter].decimalsLimit];
        [self.horizontalTextView updateText:currentNumString];
    }else if(touchY >= CGRectGetMinY(self.volView.frame) && touchY <= CGRectGetMaxY(self.volView.frame)) {
        
        touchY = touchY - CGRectGetMinY(self.volView.frame);
        double currentNum = (self.volView.currentExtremeValue.maxValue - self.volView.currentExtremeValue.minValue) * (1.0 - (touchY - [self.volView.config insetsOfKlineView].top)/ (CGRectGetHeight(self.volView.frame) - ([self.volView.config insetsOfKlineView].top + [self.volView.config insetsOfKlineView].bottom))) + self.volView.currentExtremeValue.minValue;
        
        if (currentNum < self.volView.currentExtremeValue.minValue) {
            currentNum = self.volView.currentExtremeValue.minValue;
        }else if(currentNum > self.volView.currentExtremeValue.maxValue) {
            currentNum = self.volView.currentExtremeValue.maxValue;
        }
        
        NSString *currentNumString = [NSString stringWithFormat:@"%f",currentNum];
        [self.horizontalTextView updateText:currentNumString];
    }
    
    CGSize horizontalTextSize = [self.horizontalTextView getCurrentTextSize];
    
    if (point.x <= (self.frame.size.width / 2.0)) {
        CGRect newTextRect = self.horizontalTextView.frame;
        newTextRect.origin.x = self.frame.size.width - horizontalTextSize.width;
        self.horizontalTextView.frame = newTextRect;
        
        CGRect newLineRect = self.horizontalLineView.frame;
        newLineRect.origin.x = 0.0f;
        newLineRect.size.width = self.frame.size.width - horizontalTextSize.width;
        self.horizontalLineView.frame = newLineRect;
        // 详情视图
        [self p_showDetailViewWithKLineModel:tempModel isLeft:YES];
    }else {
        
        CGRect newLineRect = self.horizontalLineView.frame;
        newLineRect.origin.x = horizontalTextSize.width;
        newLineRect.size.width = self.frame.size.width - horizontalTextSize.width;
        self.horizontalLineView.frame = newLineRect;
        // 详情视图
        [self p_showDetailViewWithKLineModel:tempModel isLeft:NO];
    }
}

/**
 数据已经刷新
 
 @param dataCenter 数据中心
 @param modelArray 刷新后的数据
 */
- (void)dataCenter:(DataCenter *)dataCenter didReload:(NSArray *)modelArray {
    // 默认的显示区域
    self.currentVisibleRange = self.kLineMainView.dataLogic.visibleRange;
    [self setNeedsDisplay];
}

/**
 数据已经被清空
 
 @param dataCenter 数据中心
 */
- (void)dataDidCleanAtDataCenter:(DataCenter *)dataCenter {
    // 默认的显示区域
    self.currentVisibleRange = self.kLineMainView.dataLogic.visibleRange;
    [self setNeedsDisplay];
}

/**
 在尾部添加了最新数据
 
 @param dataCenter 数据中心
 @param modelArray 添加后的数据
 */
- (void)dataCenter:(DataCenter *)dataCenter didAddNewDataInTail:(NSArray *)modelArray {
    // 默认的显示区域
    self.currentVisibleRange = self.kLineMainView.dataLogic.visibleRange;
    [self setNeedsDisplay];
}

/**
 在头部添加了数据
 
 @param dataCenter 数据中心
 @param modelArray 添加后的数据
 */
- (void)dataCenter:(DataCenter *)dataCenter didAddNewDataInHead:(NSArray *)modelArray {
    // 默认的显示区域
    self.currentVisibleRange = self.kLineMainView.dataLogic.visibleRange;
    [self setNeedsDisplay];
}

#pragma mark - 公共方法 -----

/**
 切换主图样式
 */
- (void)switchKLineMainViewToType:(KLineMainViewType)type {
    
    if (type && type != self.mainViewType) {
        self.mainViewType = type;
        
        switch (type) {
        
            case KLineMainViewTypeKLine:    // 只有K线
            {
                [self.kLineMainView removeAllDrawLogic];
                
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"main_bg"]];
                [self.kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithDrawLogicIdentifier:@"k_line"]];
            }
                break;
                
                
            case KLineMainViewTypeKLineWithMA:  // K线+MA
            {// 主图切为分时蜡烛图
                
                [self.kLineMainView removeAllDrawLogic];
                
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"main_bg"]];
                [self.kLineMainView addDrawLogic:[[KLineDrawLogic alloc] initWithDrawLogicIdentifier:@"k_line"]];
                [self.kLineMainView addDrawLogic:[[KLineMADrawLogic alloc] initWithDrawLogicIdentifier:@"main_ma_5_10_30"]];
            }
                break;
                
                case  KLineMainViewTypeTimeLine:    // 只有分时线
            {
                [self.kLineMainView removeAllDrawLogic];
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"main_bg"]];
                [self.kLineMainView addDrawLogic:[[KLineTimeDrawLogic alloc] initWithDrawLogicIdentifier:@"main_time"]];
            }
                break;
                
                
            case KLineMainViewTypeTimeLineWithMA:   // 分时线+MA
            {  // 主图样式切换为分时图
                
                [self.kLineMainView removeAllDrawLogic];
                [self.kLineMainView addDrawLogic:[[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"main_bg"]];
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

/**
 根据下标获得特定的元素的中心x坐标
 
 @param index 下标
 */
- (CGFloat)p_getCurrentSelectedItemCenterXWithIndex:(NSInteger)index {
    CGFloat centerX = 0.0f;
    centerX = (index - self.currentVisibleRange.x + 0.5) * self.perItemWidth;
    return centerX;
}

- (void)p_showDetailViewWithKLineModel:(KLineModel *)model isLeft:(BOOL)isLeft {
    
    if (!model) {
        return;
    }
    
    // 时间
    DetailDataModel *timeModel = [[DetailDataModel alloc] initWithName:KLocalizedString(@"trade_commission_date", @"时间") desc:[NSString gl_convertTimeStamp:(model.stamp / 1000) toFormatter:@"yy-MM-dd hh:mm"]];
    // 开
    DetailDataModel *openModel = [[DetailDataModel alloc] initWithName:KLocalizedString(@"trade_open", @"开") desc:[@(model.open) gl_numberToStringWithDecimalsLimit:self.kLineMainView.dataCenter.decimalsLimit]];
    // 高
    DetailDataModel *highModel = [[DetailDataModel alloc] initWithName:KLocalizedString(@"trade_high", @"高") desc:[@(model.high) gl_numberToStringWithDecimalsLimit:self.kLineMainView.dataCenter.decimalsLimit]];
    
    // 低
    DetailDataModel *lowModel = [[DetailDataModel alloc] initWithName:KLocalizedString(@"trade_low", @"低") desc:[@(model.low) gl_numberToStringWithDecimalsLimit:self.kLineMainView.dataCenter.decimalsLimit]];
    
    // 收
    DetailDataModel *closeModel = [[DetailDataModel alloc] initWithName:KLocalizedString(@"trade_closed", @"收") desc:[@(model.close) gl_numberToStringWithDecimalsLimit:self.kLineMainView.dataCenter.decimalsLimit]];
    
    // 量
    DetailDataModel *volModel = [[DetailDataModel alloc] initWithName:KLocalizedString(@"trade_amount_short", @"量") desc:[@(model.volume) stringValue]];
    
    [self.detailView updateContentWithDetailModels:@[timeModel,openModel,highModel,lowModel,closeModel,volModel]];
    
    CGRect newFrame = self.detailView.frame;
    if (isLeft) {
        newFrame.origin.x = self.frame.size.width - newFrame.size.width;
    }else {
        newFrame.origin.x = 0.0f;
    }
    
    self.detailView.frame = newFrame;
}

#pragma mark - 懒加载 ---------

- (KLineView *)kLineMainView {
    if (!_kLineMainView) {
        _kLineMainView = [[KLineView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - 20.0f) * 7.0/10.0) config:self.mainViewConfig];
        _kLineMainView.backgroundColor = KColorBackGround;
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
        _volView.backgroundColor = KColorBackGround;
        // 替换逻辑处理对象为主图逻辑处理对象
        [_volView replaceDataLogicWithLogic:self.kLineMainView.dataLogic];
        
        // 添加绘图算法
        KLineBGDrawLogic *bgLogic = [[KLineBGDrawLogic alloc] initWithDrawLogicIdentifier:@"vol_bg"];
        bgLogic.isHideMidDial = YES;
        [_volView addDrawLogic:bgLogic];
        [_volView addDrawLogic:[[KLineVolDrawLogic alloc] initWithDrawLogicIdentifier:@"vol"]];
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

- (VerticalView *)verticalTextView {
    if (!_verticalTextView) {
        _verticalTextView = [[VerticalView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20.0f, self.frame.size.width, 20.0f)];
        _verticalTextView.userInteractionEnabled = NO;
    }
    return _verticalTextView;
}

- (UIView *)verticalLineView {
    if (!_verticalLineView) {
        _verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0f, self.frame.size.height - CGRectGetHeight(self.verticalTextView.frame))];
        [_verticalLineView setBackgroundColor:KColorTitle_333];
        _horizontalLineView.userInteractionEnabled = NO;

    }
    return _verticalLineView;
}

- (HorizontalView *)horizontalTextView {
    if (!_horizontalTextView) {
        _horizontalTextView = [[HorizontalView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20.0f)];
        _horizontalTextView.userInteractionEnabled = NO;
    }
    return _horizontalTextView;
}

- (UIView *)horizontalLineView {
    if (!_horizontalLineView) {
        _horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.0f)];
        _horizontalLineView.backgroundColor = KColorTitle_333;
        _horizontalLineView.userInteractionEnabled = NO;
    }
    return _horizontalLineView;
}

- (DetailDataView *)detailView {
    if (!_detailView) {
        _detailView = [[DetailDataView alloc] initWithFrame:CGRectMake(0, 20.0f, 150.0f, 0.0f)];
    }
    return _detailView;
}

@end
