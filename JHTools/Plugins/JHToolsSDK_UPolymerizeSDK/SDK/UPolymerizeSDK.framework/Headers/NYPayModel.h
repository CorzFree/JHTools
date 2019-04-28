//
//  NYPayModel.h
//  PolymerizeSDK
//
//  Created by ylwl on 2017/11/1.
//  Copyright © 2017年 com.youguu.h5gameCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JH_BaseModel.h"

@interface NYPayModel : JH_BaseModel

@property (nonatomic,copy) NSString *orderID;//订单号
@property (nonatomic,copy) NSString *serverID;//服务区ID
@property (nonatomic,copy) NSString *serverName;//服务区名称
@property (nonatomic,copy) NSString *roleID;//游戏角色ID
@property (nonatomic,copy) NSString *roleName;//游戏角色名称
@property (nonatomic,copy) NSString *roleLevel;//游戏角色等级

@property (nonatomic,copy) NSString *productName;//商品名称
@property (nonatomic,copy) NSString *gameName;//游戏名称(或者商品描述)
@property (nonatomic,copy) NSString *productId;//商品序列

@property (nonatomic,copy) NSString *amount;//充值金额
@property (nonatomic,copy) NSString *extra;//扩展信息 不需要的时候请传@""
- (NSDictionary *)modelToDic;
@end
