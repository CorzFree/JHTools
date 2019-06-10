//
//  RoleData.h
//  傲风游戏SDK
//
//  Created by aofeng on 2018/8/6.
//  Copyright © 2018年 aofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoleData : NSObject

/** 角色ID*/
@property (nonatomic, copy)  NSString *roleID;
/** 角色名称*/
@property (nonatomic, copy)  NSString *roleName;
/** 角色等级*/
@property (nonatomic, copy)  NSString *roleLevel;
/** 区服ID*/
@property (nonatomic, copy)  NSString *serverId;
/** 区服名称*/
@property (nonatomic, copy)  NSString *serverName;
/** 游戏币*/
@property (nonatomic, copy)  NSString *moneyNum;
/** 角色创建时间*/
@property (nonatomic, copy)  NSString *roleCreateTime;
/** 角色等级变化时间*/
@property (nonatomic, copy)  NSString *roleLevelUpTime;
/** Vip*/
@property (nonatomic, copy)  NSString *vip;
/** 角色性别 0:男,1:女*/
@property (nonatomic, copy)  NSString *roleGender;
/** 职业ID*/
@property (nonatomic, copy)  NSString *professionID;
/** 职业名称*/
@property (nonatomic, copy)  NSString *professionName;
/** 战力*/
@property (nonatomic, copy)  NSString *power;
/** 公会名*/
@property (nonatomic, copy)  NSString *partyName;
/** 公会ID*/
@property (nonatomic, copy)  NSString *partyID;
/** 会长ID*/
@property (nonatomic, copy)  NSString *partyMasterID;
/** 会长名*/
@property (nonatomic, copy)  NSString *partyMasterName;

@end
