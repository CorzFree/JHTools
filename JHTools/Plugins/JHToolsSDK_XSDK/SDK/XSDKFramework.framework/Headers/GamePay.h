//
//  GamePay.h
//  WeChats
//
//  Created by zhanMac on 2019/6/20.
//  Copyright © 2019 Youkia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XPayData.h"
NS_ASSUME_NONNULL_BEGIN
@class GamePay;
@protocol GamepayDelegate <NSObject>

- (void)WeChatWithback:(GamePay *)wechat WitherrCode:(int)errCode;

@end

@interface GamePay : NSObject

@property (weak, nonatomic) id<GamepayDelegate>delegate;

+ (GamePay *)defaultSDK;

/*
 * 支付
 */
- (void)pay:(XPayData*)data price:(NSString *)price;

/*
 * 显示支付成功
 */
- (void)PaySuccess;

/*
 * 显示支付失败
 */
- (void)PayFailure;

- (BOOL)handleOpenURL:(NSURL *)url delegate:delegate;

@end

NS_ASSUME_NONNULL_END
