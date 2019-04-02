//
//  JNetRequest.h

//
//  Created by 降瑞雪 on 2017/4/5.
//  Copyright © 2017年 HuiYuan.NET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JNetPTypeJCard     = 10,   //骏卡
    JNetPTypePhoneCard = 12,   //电话卡
    JNetPTypeShort     = 18,    //银行卡快捷支付。
    JNetPTypeAli       = 22,   //支付宝
    JNetPTypeWChat     = 30,   //微信支付
    JNetPTypeGameCard  = 40,   //其他游戏卡
} JNetPType;

@interface JNetRequest : NSObject

@property (nonatomic,copy) NSString * token_id;         //预支付令牌。初始化之后成功之后，由汇元网后台返回。
@property (nonatomic,copy) NSString * agent_id;         //商户ID。
@property (nonatomic,copy) NSString * agent_bill_id;    //商户系统单据号。
@property (nonatomic,assign) JNetPType ptype;        //支付类型。
@property (nonatomic,copy) NSString * schemeStr;        //返回商户应用必传Schemes。
@property (nonatomic,strong) UIViewController * rootViewController; //唤起SDK的视图控制器。必传

@end
