//
//  PayParams.h
//  傲风游戏SDK
//
//  Created by aofeng on 2018/8/7.
//  Copyright © 2018年 aofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayParams : NSObject

/** 商品ID */
@property(nonatomic, strong)NSString *productID;
/** 商品名称 */
@property(nonatomic, strong)NSString *productName;
/** 商品描述 */
@property(nonatomic, strong)NSString *productDesc;
/** 订单金额 */
@property(nonatomic, assign)int price;
/** 服务器ID */
@property(nonatomic, strong)NSString *serverId;
/** 服务器名称 */
@property(nonatomic, strong)NSString *serverName;
/** 角色ID */
@property(nonatomic, strong)NSString *roleId;
/** 角色名称 */
@property(nonatomic, strong)NSString *roleName;
/** 角色等级 */
@property(nonatomic, strong)NSString *roleLevel;
/** 透传参数 */
@property(nonatomic, strong)NSString *extension;
/** 订单回调地址 */
@property(nonatomic, strong)NSString *notifyUrl;
@end
