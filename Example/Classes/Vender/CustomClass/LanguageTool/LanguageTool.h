//
//  LanguageTool.h
//  ZCPlaymate
//
//  Created by Ghostlord on 2017/6/19.
//  Copyright © 2017年 renyichun. All rights reserved.
//


/**
 应用内语言切换工具
 切换语言包路径
 */

#import <Foundation/Foundation.h>

/**
 国际化时需要强制使用的宏

 @param key 当前文本的key
 @param 描述 对当前文本的描述
 @return 对应语言的文本
 */
#define KLocalizedString(key, 描述) [[LanguageTool shareInstace].currentBundle localizedStringForKey:key value:@"" table:nil]

// 国际化的语言类型枚举
typedef enum : NSUInteger {
    KKLanguageTypeEnglish = 1,          // 英文
    KKLanguageTypeSimplified,          // 简体中文
} KKLanguageType;

@protocol LanguageToolDelegate <NSObject>

/**
 语言包已经切换成功的代理方法

 @param currentLanguageType 当前显示的语言类型
 */
- (void)delegate_languageTool_languageDidChanged:(KKLanguageType)currentLanguageType;

@end



@interface LanguageTool : NSObject
/**
 当前软件正在使用的bundle
 */
@property (readonly, strong, nonatomic) NSBundle *currentBundle;

/**
 当前软件显示的语言类型
 默认：简体中文
 */
@property (readonly, assign, nonatomic) KKLanguageType currentLanguageType;

/**
 代理
 */
@property (weak, nonatomic) id<LanguageToolDelegate>languageDelegate;


/**
 单例创建
 
 @return 语言管理工具的初始化
 */
+ (instancetype)shareInstace;

/**
 切换到指定的语言类型
 
 @param languageType 需要切换到的语言类型
 return NSBundle 切换后的语言包对象
 */
- (NSBundle * _Nullable)switchingToLanguageType:(KKLanguageType)languageType;
@end
