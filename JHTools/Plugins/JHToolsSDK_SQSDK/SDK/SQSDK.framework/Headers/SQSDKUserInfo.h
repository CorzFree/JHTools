//
//  SQSDKUserInfo.h
//  SQSDK
//
//  Created by Kaymin on 2017/7/12.
//  Copyright © 2017年 SQSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQSDKUserInfo : NSObject

@property (nonatomic, copy) NSString *userID;
/// 该属性的值可能为空
@property (nonatomic, copy) NSString *autoCode DEPRECATED_MSG_ATTRIBUTE("该属性不可用");
@property (nonatomic, copy) NSString *userToken;
/// 使用该参数，发给CP当做用户标识
@property (nonatomic, copy) NSString *userCode;
@end
