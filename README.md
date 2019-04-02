# JHTools简介
iOS游戏工程对接渠道工具：<br>
1.渠道SDK插件化，一次性对接，不同游戏只要修改配置参数，无需重新对接SDK<br> 
2.脚本化修改工程配置，适应各种SDK的工程配置要求<br> 
3.可选择性，只生成工程或者只打包等<br> 
4.根据游戏名选择出包，导出包目录结构清晰，并且导出对应的dSYM文件<br> 
5.可上传共享盘、上传fir.im或者蒲公英<br>

#JHToolsSDK使用方法
# 一、游戏接入工具
## 1、将游戏工程放置于JHToolsSDK工具目录下
    此操作只是为了方便查找原始工程经过工具打包后的工程，若不想放置于此目录下也是可以的。
## 2、原始工程引入Core库
    XCode打开游戏工程，将Core目录下的JHTollsSDKCore工程添加入游戏工程，并在"Link Binary With Libraries"中引用库，也可以先用Core目录下的工程先打成库，再引用入游戏原始工程，只是这样不方便调试
## 3.游戏接入工具代码
### 1）Appdelegate中调用以下方法
```
#import <JHToolsSDKCore/JHToolsSDKCore.h>
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //初始化应该在程序启动时调用, 也就是在didFinishLaunchingWithOptions方法里
    NSDictionary *sdkconfig = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"JHToolsSDK"];
    [[JHToolsSDK sharedInstance] initWithParams:sdkconfig];
    [[JHToolsSDK sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[JHToolsAnalytics sharedInstance] startLevel:@"1"];

    self.window.rootViewController = [[ViewController alloc] init];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[JHToolsSDK sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
 
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    [[JHToolsSDK sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}
 
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [[JHToolsSDK sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}
 
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [[JHToolsSDK sharedInstance] application:application didReceiveLocalNotification:notification];
}
 
- (void)applicationWillResignActive:(UIApplication *)application {
    [[JHToolsSDK sharedInstance] applicationWillResignActive:application];
}
 
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[JHToolsSDK sharedInstance] applicationDidEnterBackground:application];
}
 
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[JHToolsSDK sharedInstance] applicationWillEnterForeground:application];
}
 
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[JHToolsSDK sharedInstance] applicationDidBecomeActive:application];
}
 
- (void)applicationWillTerminate:(UIApplication *)application {
    [[JHToolsSDK sharedInstance] applicationWillTerminate:application];
}
 
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[JHToolsSDK sharedInstance] application:application handleOpenURL:url];
}
 
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[JHToolsSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
```
### 2）在游戏对外接口类中接入以下代码
遵守HN669SDKDelegate协议，设置代理，并且实现协议中定义的方法\
ps:因为为公共协议接口，所以回调接口并不是都有数据返回，主要用到的为登录回调、登出回调等，游戏内有功能的可以根据参数需求来定义，回调参数可以自定义
```
#pragma mark --<JHToolsSDKDelegate>
-(UIView*) GetView{
    return [self GetViewController].view;;
}
 
-(UIViewController*) GetViewController{
    return self;
}
 
//SDK初始化成功回调
-(void) OnPlatformInit:(NSDictionary*)params{
}
 
//登录成功回调
-(void) OnUserLogin:(NSDictionary*)params{
}
 
//登出回调
-(void) OnUserLogout:(NSDictionary*)params{
}
 
//支付回调
-(void) OnPayPaid:(NSDictionary*)params{
}
 
//事件回调
-(void) OnEventCustom:(NSString*)eventName params:(NSDictionary*)params{
}
```
3）游戏功能API调用
登录
```
[[JHToolsSDK sharedInstance] login];
```
登出
```
[[JHToolsSDK sharedInstance] logout];
```
切换账号
```
[[JHToolsSDK sharedInstance] switchAccount];
```
显示个人中心\
Note:部分渠道要求游戏内必须要有［个人中心］按钮，点击进入渠道SDK的个人中心界面.但是因为是部分渠道有这个接口，部分渠道没有提供这个接口，所以，对于没有提供该接口的渠道，该方法不做任何逻辑。游戏层需要根据支付支持该方法的判定，来显示或者隐藏该按钮。调用该方法时，先判断当前渠道是否提供了个人中心接口：
```
if([[JHToolsSDK sharedInstance].defaultUser hasAccountCenter]){
   [[JHToolsSDK sharedInstance] showAccountCenter];
}
```
支付接口\
在调用支付的时候，游戏中需要传入对应的参数，然后调用支付插件的pay方法：
```
 JHToolsProductInfo* productInfo = [[JHToolsProductInfo alloc] init];
    productInfo.orderID = @"1782341234";//订单号
    productInfo.productName = @"礼包1";//产品名
    productInfo.productDesc = @"礼包1";//产品描述
    productInfo.productId = @"com.test.6";//产品描述
    productInfo.price = [NSNumber numberWithInt:1];//价格，单位元
    productInfo.buyNum = 1;//购买数量
    productInfo.coinNum = 900;//获取元宝数量
    productInfo.roleId = @"12345";//角色ID
    productInfo.roleName = @"角色";//角色名
    productInfo.roleLevel = @"66";//角色等级
    productInfo.serverId = @"1";//区服ID
    productInfo.serverName = @"桃源";//区服名
    productInfo.vip = @"1";//vip等级
    productInfo.extension = @"hjghjklhjk";//透传数据
    productInfo.notifyUrl = @"http://110.54.33.45/game/pay/notify";//回调URL，若使用后台配置，此处可不填写
    [[HN669SDK sharedInstance] pay:productInfo];
//参数dic是一个HN669ProductInfo对象 支付成功的回调，可以在上面OnPayPaid回调方法中进行处理。一般网游这里不需要做特殊的处理，因为支付是异步的，这里支付成功，仅仅是SDK支付请求成功，并不代表玩家得到了游戏币。真正充值成功，是异步通知到游戏服务器的。
```
提交用户数据
```
JHToolsUserExtraData* extraData = [[JHToolsUserExtraData alloc] init];
extraData.dataType = TYPE_ENTER_GAME;//上传角色场景 登录/进入游戏/升级、退出游戏等
extraData.roleID = @"testRole";//角色ID
extraData.roleName = @"角色名称";//角色名称
extraData.serverID = 1;//区服ID
extraData.serverName = @"第一区";//区服名称
extraData.roleLevel = @"1";//角色等级
extraData.moneyNum = 100;//当前角色身上拥有的游戏币数量
extraData.roleCreateTime = time(NULL);//角色创建时间
extraData.roleLevelUpTime = time(NULL); //角色最近升级时间
[[JHToolsSDK sharedInstance] submitExtraData:extraData];
```
# 二、渠道SDK接入
# 三、使用工具打包
当游戏接入完成，并接入完渠道SDK后，就可以使用工具直接出包了
终端进入工具目录，输入./buildscript/build.py JHToolsPloy/(游戏.xcodeproj文件) JHToolsPloy/ （-n 只配置工程，不打包）
![](https://pan.baidu.com/s/1gsgDAjQyW6ZK7M7fjKX8Zg)
