//
//  LTOrder.h
//  LTSDK
//
//  Created by F on 2018/11/10.
//  Copyright © 2018年 LT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTOrder : NSObject

/**
 游戏id
 */
@property (nonatomic, copy) NSString * gameId;

/**
 用户id
 */
@property (nonatomic, copy) NSString * uid;
/**
 当前订单时间，秒
 */
@property (nonatomic, assign) int  time;

/**
 支付时的游戏区服名称（没有的话。可以写1，但是不能为空）
 */
@property (nonatomic, copy) NSString * server;

/**
 支付时角色信息名称 （没有的话。可以写1，但是不能为空）
 */
@property (nonatomic, copy) NSString * role;

/**
 商品ID（没有的话。可以写1，但是不能为空）
 */
@property (nonatomic, copy) NSString * goodsId;

/**
 商品名,如：元宝
 */
@property (nonatomic, copy) NSString * goodsName;

/**
 商品价格(元) 例：1.00
 */
@property (nonatomic, copy) NSString * money;

/**
 游戏订单号(回传时原样返回)
 */
@property (nonatomic, copy) NSString * cpOrderId;

/**
 额外透传参数(原样返回)
 */
@property (nonatomic, copy) NSString * ext;

/**
 订单签名（小写）
 */
@property (nonatomic, copy) NSString * sign;

/**
 固定md5
 */
@property (nonatomic, copy) NSString * signType;

/**
 支付签名
 */
@property (nonatomic, copy) NSString * key;

@end
