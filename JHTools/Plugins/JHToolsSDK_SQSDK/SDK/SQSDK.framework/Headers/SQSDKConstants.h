//
//  SQSDKConstants.h
//  SQSDK
//
//  Created by Kaymin on 2017/6/15.
//  Copyright © 2017年 SQSDK. All rights reserved.
//

#ifndef SQSDKConstants_h
#define SQSDKConstants_h

/**
 * 游戏支持设备方向枚举
 */
typedef NS_OPTIONS(NSUInteger, SQSDKScreenOrientation) {
	
	SQSDKScreenOrientationPortrait         =     1,    //--支持竖版转向，通常使用
	SQSDKScreenOrientationLandscape        =     2     //--支持横版转向，通常使用
};

/**
 * 支付状态
 */
typedef NS_ENUM(NSUInteger, SQSDKPayState) {
	SQSDKPaySuccess		=	1,		///< 支付成功
	SQSDKPayFailure		=	2,		///< 支付失败
	SQSDKPayCancel		=	3,		///< 取消支付
};

extern NSString *const SQSDKInitCompletedNotification;
extern NSString *const SQSDKUserLoginNotification;
extern NSString *const SQSDKUserLogoutNotification;
extern NSString *const SQSDKSwitchAccountNotification;
extern NSString *const SQSDKReportNotification;
extern NSString *const SQSDKPayCompletedNotification;
extern NSString *const SQSDKRechargeCompletedNotification;

extern NSString *const SQSDKErrorDomain;

extern NSString *const SQSDKPayInfoKey;
extern NSString *const SQSDKPayStateKey;


#endif /* SQSDKConstants_h */
