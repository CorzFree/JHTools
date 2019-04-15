//
//  LANTRequestModelerCart.h
//  BanLA
//
//  Created byJiaLan on 16/11/23.
//  Copyright © 2016年 LanguageBan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANTRequestModelerCart : NSObject
/** 游戏名 */
@property (nonatomic,strong)NSString *LANTgameName;
/** 游戏方如有需要传入的参数请传入这个 */
@property (nonatomic,strong)NSString *LANTattach;
/** 角色名 */
@property (nonatomic,strong)NSString *LANTroleName;

/** 订单号 */
@property (nonatomic,strong)NSString *LANTorderOn;

/** 商品描述 */
@property (nonatomic,strong)NSString *LANTbody;

/** 等级 */
@property(nonatomic, strong)NSString *LANTRoleLevel;

/** 价格 */
@property (nonatomic,strong)NSString *LANTamount;

/** 商品数量 */
@property (nonatomic,strong)NSString *LANTgoodsNum;

/** 服务器id */
@property (nonatomic,strong)NSString *LANTserverID;

/** 苹果内购的商品id */
@property (nonatomic,strong)NSString *LANTproductID;

/** 详情见文档 */
@property(nonatomic, strong)NSString *LANTUrl;
@end
