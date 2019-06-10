//
//  FileSizeManage.h
//  BGWallpaper
//
//  Created by yuling on 15/12/4.
//  Copyright © 2015年 yuling. All rights reserved.
//  autor ning 计算缓存 文件 大小

#import <Foundation/Foundation.h>

@interface YLFileSizeManage : NSObject
/**
 *  以字典形式获取文件内容
 *  文件夹默认在[NSBundle mainBundle] 下
 *  fileName 文件名 若在文件夹内 则添加文件夹名字 比如 _CodeSignature/Info.plist
 */
+(NSMutableDictionary *)readMainBundleFileWithFileName:(NSString*)fileName;
///**
// *  计算路径下文件集大小
// */
//+(float)folderSizeAtPath:(NSString *)path;
/**
 *  计算文件大小
 */
+(float)fileSizeAtPath:(NSString *)path;
///**
// *  清除文件缓存
// */
//+(void)clearCache:(NSString *)path;




/**
 主目录
 */
+ (NSString *)homePath;
/**
 临时目录
 */
+ (NSString *)tmpPath;
/**
 Documents路径
 */
+ (NSString *)documentPath;
/**
 Library/Caches路径
 */
+ (NSString *)caChesPath;
/**
 NSUserDefaults
 */
+ (NSUserDefaults *)preferencesPath;
/** 读取 */
+(NSDictionary *)readPlist:(NSString *)fileName;
/** XML的保存 */
+(BOOL)savePlist:(NSString *)fileName andDic:(NSDictionary *)dict;
@end
