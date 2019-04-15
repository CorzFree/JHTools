//
//  LANTRoleModelerCart.h
//  BanLA
//
//  Created byJiaLan on 16/11/24.
//  Copyright © 2016年 LanguageBan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANTRoleModelerCart : NSObject
/** 角色名字 */
@property (nonatomic,strong)NSString *LANTRoleName;

/** 角色等级 */
@property (nonatomic,strong)NSString *LANTRoleLevel;

/** 服务器id */
@property (nonatomic,strong)NSString *LANTSerVerID;

/** 服务器名字, urlencode(转码) */
@property (nonatomic,strong)NSString *LANTServerName;

@end
