//
//  SQSDKRoleInfo.h
//  SQSDK
//
//  Created by LinChao on 2017/6/20.
//  Copyright © 2017年 SQSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQSDKRoleInfo : NSObject

/**
 区服代码
 */
@property (nonatomic, copy) NSString *areaCode;

/**
 区服名称
 */
@property (nonatomic, copy) NSString *areaName;

/**
 角色代码
 */
@property (nonatomic, copy) NSString *roleCode;

/**
 角色名
 */
@property (nonatomic, copy) NSString *roleName;

/**
 角色等级
 */
@property (nonatomic, copy) NSString *roleLevel;

/**
 角色创建时间
 */
@property (nonatomic, copy) NSString *roleCreateDate;

/**
 角色性别
 */
@property (nonatomic, copy) NSString *roleSex;

/**
 职业代码
 */
@property (nonatomic, copy) NSString *proCode;

/**
 职业名称
 */
@property (nonatomic, copy) NSString *proName;

/**
 推广商代码
 */
@property (nonatomic, copy) NSString *partyCode;

/**
 推广商名称
 */
@property (nonatomic, copy) NSString *partyName;

/**
 推广商等级
 */
@property (nonatomic, copy) NSString *partyLevel;

/**
 推广商
 */
@property (nonatomic, copy) NSString *partyChairman;

/**
 Vip等级
 */
@property (nonatomic, copy) NSString *vipLevel;

/**
 金币
 */
@property (nonatomic, assign) NSInteger goldValue;

/**
 扩展参数
 */
@property (nonatomic, strong) NSDictionary *expandInfo;

/**
 构造游服报道对象
 
 @param areaCode		区服代码
 @param areaName		区服名称
 @param roleCode		角色代码
 @param roleName		角色名
 @param roleLevel		角色等级
 @param roleCreateDate	角色创建时间
 @param roleSex			角色性别
 @param proCode			职业代码
 @param proName			职业名称
 @param partyCode		推广商代码
 @param partyName		推广商名称
 @param partyLevel		推广商等级
 @param partyChairman	推广商
 @param vipLevel		Vip等级
 @param goldValue		金币
 @param expandInfo		扩展参数
 */
+ (SQSDKRoleInfo *)roleInfoWithAreaCode:(NSString *)areaCode
							   areaName:(NSString *)areaName
							   roleCode:(NSString *)roleCode
							   roleName:(NSString *)roleName
							  roleLevel:(NSString *)roleLevel
						 roleCreateDate:(NSString *)roleCreateDate
								roleSex:(NSString *)roleSex
								proCode:(NSString *)proCode
								proName:(NSString *)proName
							  partyCode:(NSString *)partyCode
							  partyName:(NSString *)partyName
							 partyLevel:(NSString *)partyLevel
						  partyChairman:(NSString *)partyChairman
							   vipLevel:(NSString *)vipLevel
							  goldValue:(NSInteger )goldValue
							 expandInfo:(NSDictionary *)expandInfo;

@end
