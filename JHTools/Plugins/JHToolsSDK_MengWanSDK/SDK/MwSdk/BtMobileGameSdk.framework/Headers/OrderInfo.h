//
//  OrderInfo.h
//
//  Created by Mak .
//  Copyright © Mak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject<NSCopying>
@property (nonatomic, strong) NSString *goodsPrice;//商品价格
@property (nonatomic, strong) NSString *goodsName;//商品名称
@property (nonatomic, strong) NSString *goodsDesc;//商品描述
@property (nonatomic, strong) NSString *productId;//内购产品id
@property (nonatomic, strong) NSString *extendInfo;//此字段会透传到游戏服务器，可拼接
@property (nonatomic, strong) NSString *gameVersion;//游戏版本号

@property (nonatomic, strong) NSString *roleId; // 角色id
@property (nonatomic, strong) NSString *roleName; // 角色名称
@property (nonatomic, strong) NSString *serverId; // 区服id
@property (nonatomic, strong) NSString *serverName; // 区服名称
@end
