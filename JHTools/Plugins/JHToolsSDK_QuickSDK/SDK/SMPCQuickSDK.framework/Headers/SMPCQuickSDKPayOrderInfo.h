//
//  SMPCQuickSDKPayOrderInfo.h
//  SMPCQuickSDK
//
//

#import <Foundation/Foundation.h>

@interface SMPCQuickSDKPayOrderInfo : NSObject
@property(nonatomic,copy) NSString *goodsID;    //商品ID IAP时为苹果开发者后台配置的商品id，必填
@property(nonatomic,copy) NSString *productName;  //商品名称，必填
@property(nonatomic,copy) NSString *cpOrderID;  //游戏订单ID，必填
@property(nonatomic,assign) NSUInteger count;     //商品数量，必填
@property(nonatomic,assign) float amount;         //商品总价,必填，这个很重要
@property(nonatomic,copy) NSString *callbackUrl;  //购买回调地址，选填,优先使用服务器端配置的
@property(nonatomic,copy) NSString *extrasParams; //透传字段，选填，服务器回调原样传递

//deprecated 废弃的，可以不传值
@property(nonatomic,assign) float price;          //商品单价，选填,如果渠道需要，Quick将通过总价和数量来计算
@property(nonatomic,copy) NSString *productDesc;   //商品描述，选填，默认QuickSDK使用“数量+商品名称“拼接，如果数量为1，使用商品名称
@property(nonatomic,copy) NSString *quantifier;     //商品量词，选填，可以为@""空串

+ (instancetype)info;//获取一个对象属性值为nil，数值属性为0的实例
@end
