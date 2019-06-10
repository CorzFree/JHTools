
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//参数
///商品id
extern NSString * const VTSsOdJSOh;
extern NSString * const ioJshFlykS;///商品名字
extern NSString * const KSthgfEGnh;///商品描述
extern NSString * const VJfDbNGlCK;///扩展参数，可选
extern NSString * const YitSbUkYUT;///商品金额
extern NSString * const FTUzGsUfTL; ///单号



///角色所在的serverid
extern NSString * const eniEGykVbk;
///服务器名
extern NSString * const RZUhfdGube;
///角色id
extern NSString * const lRJIkiYtdM;
///角色名
extern NSString * const nZORUtXrZg;
///角色等级
extern NSString * const ttgDDlJFuv;
///公会名
extern NSString * const MhzGuYbzdC;
///角色vip等级
extern NSString * const RkttKdmjye;
///角色游戏余
extern NSString * const ZMNmByHXZr;
///数据类型，1为进入游戏，2为创建角色，3为角色升级，4为退出
extern NSString * const CdHIhvouco;


//浮点可选参数
extern NSString * const NgYtlFJSvL;//浮点初始化的中心y轴位置
extern NSString * const MgJInUOKNY;//浮点初始化在屏幕左边还是右边

///创建角色的时间 时间戳
extern NSString * const bcjclJYoSU;
///角色等级变化时间 时间戳
extern NSString * const hszlJRGnhG;
///货类型名称
extern NSString * const NknGBMTCjo;

typedef void (^GameMainThreadCallBack)(NSDictionary *responseDic);

@interface  HSjIFFlJdj: NSObject
///
+ (void)vTesLCcymK:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

///登出
+ (void)KjzRsSMTBR;

///显示登录界面
+ (void)RXXmduEbni:(GameMainThreadCallBack)receiverBlock;

///登出回调接口
+(void)hZOsKkBuFj:(GameMainThreadCallBack)receiverBlock;

///向服务器发送信息
+(void)VcMFelcCek:(NSDictionary*)info failedBlock:(void(^)())failedBlock;

///发送信息成功回调
+(void)ZyFKYukCys:(GameMainThreadCallBack)receiverBlock;

///设置角色信息
+(void)OXRigyVuTg:(NSDictionary*)roleInfo;

///设置自动登录
+(void)ElBtRRbSFe:(BOOL)isAutoLogin;

+ (void)YHYVOhZbCR:(NSDictionary *)floatViewInfo;

//如果在某些场景有必要隐藏浮点，可以调用这个方法。
+ (void)JNUMRdtcHn;

@end
