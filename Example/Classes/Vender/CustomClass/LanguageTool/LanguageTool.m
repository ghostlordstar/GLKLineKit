//
//  LanguageTool.m
//  ZCPlaymate
//
//  Created by Ghostlord on 2017/6/19.
//  Copyright © 2017年 renyichun. All rights reserved.
//

// 语言切换管理工具

#import "LanguageTool.h"

// 语言类型本地化时的关键字
#define kUserDefaultLanguageKey @"GLCurrentDisplayLanguage"


@interface LanguageTool()

/**
 当前软件正在使用的bundle
 */
@property (strong, nonatomic) NSBundle *currentBundle;

/**
 当前软件显示的语言类型
 默认：英文
 */
@property (assign, nonatomic) KKLanguageType currentLanguageType;

@end


@implementation LanguageTool
// 单例对象
static LanguageTool *instance = nil;

+(instancetype)shareInstace
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(nil == instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(nil == instance) {
        
        instance = [super allocWithZone:zone];
            
        }
    });
    return instance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return instance;
}

#pragma mark ------ 懒加载 --------

/**
 当前显示的语言类型

 @return 当前显示的语言类型
 */
- (KKLanguageType)currentLanguageType {
    
    _currentLanguageType = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultLanguageKey];
    if(!(_currentLanguageType >= 1 && _currentLanguageType <= 2)) {
        
        _currentLanguageType = KKLanguageTypeEnglish;

    }
    return _currentLanguageType;
}


/**
 当前的bundle

 @return 当前正在使用的bundle
 */
- (NSBundle *)currentBundle {
    
    if (!_currentBundle) {
        
        _currentBundle = [self switchingToLanguageType:self.currentLanguageType];
        
        if(!_currentBundle) {
            _currentBundle = [NSBundle mainBundle];
        }
    }
    return _currentBundle;
}

#pragma mark ----- 自定义方法 ------

/**
 切换到指定的语言类型
 
 @param languageType 需要切换到的语言类型
 return NSBundle 切换后的语言包对象
 */
- (NSBundle * _Nullable)switchingToLanguageType:(KKLanguageType)languageType {
    
    if(!(languageType >= 1 && languageType <= 3)) {
        // 默认简体中文
        languageType = 1;
    }
    
    NSString *languagePackageName = @"";
    
    switch (languageType) {
        case KKLanguageTypeSimplified:
        {
            languagePackageName = @"zh-Hans-CN";
            break;
        }
        case KKLanguageTypeEnglish:
        {
            languagePackageName = @"en";
            break;
        }
            
        default:
            // 默认是简体中文包
        {
            languagePackageName = @"en";
            break;
        }
    }
    
    
    // 获得语言包所在的目录
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:languagePackageName ofType:@"lproj"];
    NSBundle *languageBundle = nil;
    // 如果目录存在，就切换语言文件所在的bundle
    if(!isStrEmpty(bundlePath)) {
        
        languageBundle = [NSBundle bundleWithPath:bundlePath];
        
        // 切换bundle
        if(languageBundle) {
            _currentBundle = languageBundle;
            
            [[NSUserDefaults standardUserDefaults] setInteger:languageType forKey:kUserDefaultLanguageKey];
            // 立即同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else {
            
            _currentBundle = [NSBundle mainBundle];
            [[NSUserDefaults standardUserDefaults] setInteger:KKLanguageTypeSimplified forKey:kUserDefaultLanguageKey];
            // 立即同步
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        // 发送切换语言完成的消息
        if(_languageDelegate && [_languageDelegate respondsToSelector:@selector(delegate_languageTool_languageDidChanged:)]) {
            
            [_languageDelegate delegate_languageTool_languageDidChanged:self.currentLanguageType];
            
        }
    }
    
    return languageBundle;
}


@end
