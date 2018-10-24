//
//  Constants.h
//  GLKLineKit
//
//  Created by walker on 2018/10/10.
//  Copyright © 2018 walker. All rights reserved.
//

/* 常量定义 */

#ifndef Constants_h
#define Constants_h

// ----------- 防空判断 ------------------
/** 字符串防空判断 */
#define isStrEmpty(string) (string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0))

/** 数组防空判断 */
#define isArrEmpty(array) (array == nil || array == NULL || (![array isKindOfClass:[NSArray class]]) || array.count == 0)

/** 字典防空判断 */
#define isDictEmpty(dict) (dict == nil || dict == NULL || (![dict isKindOfClass:[NSDictionary class]]) || dict.count == 0)

// --------- 适配公共宏 ------
/** 控件缩放比例，按照宽度计算(四舍五入) */
#define SCALE_Length(l) (IS_PORTRAIT ? round((SCREEN_WIDTH/375.0*(l))) : round((SCREEN_WIDTH/667.0*(l))))

/** 是否是异形屏 */
#define IS_HETERO_SCREEN (GL_iPhone_X || GL_iPhone_X_Max)

/** 是否是竖屏 */
#define IS_PORTRAIT (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))

// ------- RGB color 转换 ---------------
/* 根据RGB获得颜色值 */
#define kColorRGB(r , g , b) kColorRGBA(r , g , b ,1.0f)

/* 根据RGB和alpha值获得颜色 */
#define kColorRGBA(r , g , b ,a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

// ------ 导航栏和Tabbar针对iPhone X 的适配  ------
#define Nav_topH (IS_HETERO_SCREEN ? 88.0 : 64.0)
#define Tab_H (IS_HETERO_SCREEN ? 83.0 : 49.0)
#define NavMustAdd (IS_HETERO_SCREEN ? 34.0 : 0.0)
#define TabMustAdd (IS_HETERO_SCREEN ? 20.0 : 0.0)
#define StatusBar_H  (IS_HETERO_SCREEN ? 44.0 : 20.0)
#define NavigationItem_H   (44.0)

// -------- 尺寸  --------------------
/* 屏幕宽 */
#define SCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)

/* 屏幕高 */
#define SCREEN_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

// --------- 手机尺寸型号 --------
#define GL_iPhone_4x        (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 480)
#define GL_iPhone_5x        (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 568)
#define GL_iPhone_6x        (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 667)
#define GL_iPhone_plus      (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 736)
#define GL_iPhone_X         (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)   // iPhone X,    iPhone XS
#define GL_iPhone_X_Max     (SCREEN_WIDTH == 414 && SCREEN_HEIGHT == 896)   // iPhone XR,   iPhone XS Max


// ---------- 版本号相关 ---------
/* 当前版本号 */
#define OSVERSION ([[UIDevice currentDevice].systemVersion floatValue])


// ---------- 常用颜色 -----------
#define KColorTheme                        [UIColor colorWithHex:0xFF9224]     // 主题颜色，橘黄色
#define KColorLong                         [UIColor colorWithHex:0x4FB336]     // 上涨颜色
#define KColorShort                        [UIColor colorWithHex:0xE70F56]     // 下跌颜色
#define KColorLongBG                       [UIColor colorWithHex:0xEDF7EB]     // 上涨背景颜色
#define KColorShortBG                      [UIColor colorWithHex:0xFDE7EE]     // 下跌背景颜色
#define KColorTitle_333                    [UIColor colorWithHex:0x333333]     // 用于主要文字提示，标题，重要文字
#define KColorNormalText_666               [UIColor colorWithHex:0x666666]     // 正常字体颜色，二级文字，标签栏
#define KColorTipText_999                  [UIColor colorWithHex:0x999999]     // 提示文字，提示性文字，重要级别较低的文字信息
#define KColorBorder_ccc                   [UIColor colorWithHex:0xcccccc]     // 边框颜色，提示性信息
#define KColorSeparator_eee                [UIColor colorWithHex:0xeeeeee]     // 分割线颜色，宽度1像素
#define KColorGap                          [UIColor colorWithHex:0xf9f9f9]     // 背景间隔色彩
#define KColorBackGround                   [UIColor colorWithHex:0xffffff]     // 白色背景色
#define KColorText_000000                  [UIColor colorWithHex:0x000000]     // 黑色

#endif /* Constants_h */
