#import "LBSDK.h"
#import "LBSDK+pay.h"

@class LBPayConfigure;
@interface LBSDK (pay)<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) LBPayConfigure *payConfigure;

//调起支付
- (void)LBPayOrderWithConfig:(LBPayConfigure *)config;

-(void)LBPayQuickConfig:(LBPayConfigure *)config;

//在APP每次进入后台时就清除默认的付款方式,下次支付时会重新获取支付方式,并再次记录
- (void)deleteStatus;
@end

@interface LBPayConfigure : NSObject

@property (nonatomic, copy) NSString *username;               //sdk登录账号（sdk登录返回的uid)

@property (nonatomic, copy) NSString *money;                    //产品金额（单位为分）

@property (nonatomic, copy) NSString *chanPinID;              //分配的支付产品ID

@property (nonatomic, copy) NSString *roleId;                 //角色ID

@property (nonatomic, copy) NSString *serverId;               //服务器ID

@property (nonatomic, copy) NSString *orderNumber;            //订单号

@property (nonatomic, copy) NSString *cpOrderId;              //cp端订单号

@property (nonatomic, copy) NSDictionary *cpExpansion;        //cp端扩展参数

@property (nonatomic, copy) NSString *productId;              //苹果内购id

@property (nonatomic, copy) NSString *orderTitle;             //订单标题

@property (nonatomic, copy) NSString *orderDesc;              //订单描述

@property (nonatomic, copy) NSString *gwdz;                   //应用的官网URL地址，必须保证公网能访问 （没有地址的话可以随意传一个链接）

@property (nonatomic, copy) NSString *urlScheme;              //本应用的urlScheme

@property (nonatomic, copy) NSString *OrderKey;              //订单key，我方会提供给贵方

@end
