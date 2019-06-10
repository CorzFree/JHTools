//
//  LTRoleModel.h
//  LTSDK
//
//  Created by casic on 2018/11/13.
//  Copyright © 2018年 LT. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LTRoleModel : NSObject

/**
 游戏id
 */
@property (nonatomic, copy) NSString * gameId;

/**
 角色创建时间
 */
@property (nonatomic, copy) NSString * roleCreateTime;

/**
 用户id
 */
@property (nonatomic, copy) NSString * uid;

/**
 用户名
 */
@property (nonatomic, copy) NSString * username;

/**
 区服ID
 */
@property (nonatomic, copy) NSString * serverId;

/**
 区服名称
 */
@property (nonatomic, copy) NSString * serverName;

/**
 游戏内角色ID
 */
@property (nonatomic, copy) NSString * userRoleId;

/**
 游戏角色名
 */
@property (nonatomic, copy) NSString * userRoleName;

/**
 角色游戏内货币余额
 */
@property (nonatomic, copy) NSString * userRoleBalance;

/**
 角色VIP等级
 */
@property (nonatomic, copy) NSString * vipLevel;

/**
 角色等级
 */
@property (nonatomic, copy) NSString * userRoleLevel;

/**
 角色已充值金额
 */
@property (nonatomic, copy) NSString * gameRoleMoney;
/**
 公会/社团ID
 */
@property (nonatomic, copy) NSString * partyId;
/**
 公会/社团名称
 */
@property (nonatomic, copy) NSString * partyName;

/**
 角色性别[no 未设置 male 男 famale 女]
 */
@property (nonatomic, copy) NSString * gameRoleGender;

/**
 角色战力
 */
@property (nonatomic, copy) NSString * gameRolePower;

/**
 Md5加密串
 */
@property (nonatomic, copy) NSString * sign;

/**
 角色在帮派中的ID
 */
@property (nonatomic, copy) NSString * partyRoleId;

/**
 角色在帮派中的名称
 */
@property (nonatomic, copy) NSString * partyRoleName;

/**
 角色职业ID
 */
@property (nonatomic, copy) NSString * professionId;

/**
 角色职业名称
 */
@property (nonatomic, copy) NSString * profession;

/**
 上传角色信息key
 */
@property (nonatomic, copy) NSString * key;
/**
 生成签名sign
 */
- (NSString *)makeSign;
@end


