//
//  SQSDKPayInfo.h
//  SQSDK
//
//  Created by LinChao on 2017/6/20.
//  Copyright © 2017年 SQSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQSDKPayInfo : NSObject

/**
 游戏厂商订单号
 */
@property (nonatomic, copy) NSString *cpOrderNo;

/**
 订单标题
 */
@property (nonatomic, copy) NSString *orderTitle;

/**
 道具代码
 */
@property (nonatomic, copy) NSString *itemCode;

/**
 道具名称
 */
@property (nonatomic, copy) NSString *itemName;

/**
 订单单价（分）
 */
@property (nonatomic, assign) long unitPrice;

/**
 数量
 */
@property (nonatomic, assign) NSInteger amount;

/**
 订单总价（分）
 */
@property (nonatomic, assign) long totalPrice;

/**
 区服名
 */
@property (nonatomic, copy) NSString *AreaName;

/**
 区服ID
 */
@property (nonatomic, copy) NSString *AreaCode;
/**
 角色ID
 */
@property (nonatomic, copy) NSString *RoleCode;

/**
 角色名
 */
@property (nonatomic, copy) NSString *RoleName;
/**
 回调参数  500字内
 */
@property (nonatomic, copy) NSString *callBackData;

/**
 扩展参数
 */
@property (nonatomic, strong) NSDictionary *expandInfo;

/**
 构造支付报道对象
 
 @param cpOrderNo		游戏厂商订单号
 @param orderTitle		订单标题
 @param itemCode		道具代码
 @param itemName		道具名称
 @param unitPrice		订单单价（分）
 @param amount			数量
 @param totalPrice		订单总价（分）
 @param areaName 区服名
 @param areaCode 区服ID
 @param roleCode 角色ID
 @param roleName 角色名
 @param callBackData 回调参数
 @param expandInfo 拓展参数
 @return 支付对象
 */
+ (SQSDKPayInfo *)payInfoWithCpOrderNo:(NSString *)cpOrderNo
							orderTitle:(NSString *)orderTitle
							  itemCode:(NSString *)itemCode
							  itemName:(NSString *)itemName
							 unitPrice:(long)unitPrice
								amount:(NSInteger)amount
							totalPrice:(long)totalPrice
							  AreaName:(NSString *)areaName
							  AreaCode:(NSString *)areaCode
							  RoleCode:(NSString *)roleCode
							  RoleName:(NSString *)roleName
						  callBackData:(NSString *)callBackData
							expandInfo:(NSDictionary *)expandInfo;

/**
 对象转换成字典

 @return 字典参数
 */
- (NSDictionary *)convertToDicParam;
@end
