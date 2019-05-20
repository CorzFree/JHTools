//
//  SwiftFintech_Tool_SDK.h
//  SwiftFintech.Tool.SDK
//
//  Created by 球球 on 2017/10/20.
//  Copyright © 2017年 球球. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SwiftFintechToolSDK : NSObject

+(SwiftFintechToolSDK*)shareInstance;


/**
 WebView根据URL跳转
 @param url url
 @return   YES 跳转   NO 不跳转
 */
-(BOOL)urlJump:(NSURL*)url;

/**
 判断是否安装了
 @param url url
 @return YES安装了  NO未安装
 */
- (BOOL)isInstall:(NSURL*)url;

@end
