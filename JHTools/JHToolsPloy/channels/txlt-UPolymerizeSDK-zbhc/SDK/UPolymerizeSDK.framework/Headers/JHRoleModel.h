//
//  PlayerModel.h
//  PolymerizeSDK
//
//  Created by YuLing on 2017/11/22.
//  Copyright © 2017年 com.youguu.h5gameCenter. All rights reserved.
//
#import "JH_BaseModel.h"
@interface JHRoleModel : JH_BaseModel

@property(nonatomic,copy) NSString *JH_serverID;//角色所在的serverid  默认传 @“1”
@property(nonatomic,copy) NSString *JH_serverName;//所在服务器名称     默认传 @“xx服”
@property(nonatomic,copy) NSString *JH_roleID;//角色ID               默认传 @“001”
@property(nonatomic,copy) NSString *JH_rolename;//角色名称            默认传 @“小鱼”
@property(nonatomic,copy) NSString *JH_level;//用户等级               默认传 @“1”


- (NSDictionary *)modelToDic;
@end
