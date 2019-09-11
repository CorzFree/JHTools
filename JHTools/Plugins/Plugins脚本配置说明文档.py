#一、mods配置文件
mods = {
    #工程引入folder名，下面防止脚本引入文件
    "group": "JHToolsSDK_AAA",
    #工程所需导入文件
    "files": [
        "libJHToolsSDK_AAA.a"
    ],
    #工程所需引入文件夹
    "folders":[
        "SDK"
    ],
    #compiler_flags编译文件配置选项
    "compiler_flags":{
         "-fno-objc-arc":[
               "OpenUDID.m"
         ]
    },
    #工程所需引入的.framework
    "frameworks": [
         "CoreGraphics.framework"
    ],
    #工程所需引入的lib文件
    "libs": [
         "libc++.dylib"
    ]
}


#二、配置参数
#1.创建新插件工程命令:
cd Plugins
python create_plugin.py JHToolsSDK_AAA

#2.配置other link flag
project.add_other_ldflags('-ObjC')

#3.配置支持Https
infoPlist["NSAppTransportSecurity"] = { "NSAllowsArbitraryLoads": True }

#4.白名单
self.addAppQueriesSchemes(["alipay", "alipayqr"])

#5.配置URLScheme（两种方式）
self.addBundleURLType(CFBundleTypeRole="Editor", CFBundleURLName="urlScheme", CFBundleURLSchemes=[self.getBundleId()])
self.addBundleURLType([self.getBundleId()])

#6.添加动态库
self.embed_binary("SDK/CYouKit.framework")

#7.info.plist文件新增数据
infoPlist['key'] = "0"
self.updateInfoPlist({“key”:{“key”:”value”}})#添加字典

#8.设置Enable Bitcode
project.enable_bitcode("NO")

#9.配置权限
infoPlist['NSCameraUsageDescription'] = ""
infoPlist['NSPhotoLibraryAddUsageDescription'] = ""
infoPlist['NSPhotoLibraryUsageDescription'] = ""
    
#10.配置preprocessor macros参数
project.preprocessor_macros("HAVE_CONFIG_H")

#11.配置enable object-c exception参数
project.enable_objc_exception("YES")
    
#三、Plugins聚合对接代码：
#1.登录验证
    [HNPloyProgressHUD showLoading:@"登录验证..."];
    [[JHToolsSDK sharedInstance].proxy accountVerification:@{@"uid":uid,@"ticket":ticket} responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
     NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
     if (code != nil && [code isEqualToString:@"1"]) {
     [HNPloyProgressHUD showSuccess:@"登录验证成功！"];
     [JHToolsSDK sharedInstance].proxy.userID = [JHToolsUtils getResponseUidWithDict:data];
     //回调返回参数
     id sdkDelegate = [JHToolsSDK sharedInstance].delegate;
     if (sdkDelegate && [sdkDelegate respondsToSelector:@selector(OnUserLogin:)]) {
     [sdkDelegate OnUserLogin:data];
     }
     }else{
     [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"登录验证失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
     }
     }];
     
#2.预订单
    [[JHToolsSDK sharedInstance].proxy getOrderWith:profuctInfo responseHandler:^(NSURLResponse *response, id data, NSError *connectionError) {
     NSString *code = [JHToolsUtils getResponseCodeWithDict:data];
     if (code != nil && [code isEqualToString:@"1"]) {
     NSString *orderNo = [JHToolsUtils stringValue:data[@"data"][@"order_no"]];
     
     }else{
     [HNPloyProgressHUD showFailure:[NSString stringWithFormat:@"创建聚合订单失败！(%@)", [JHToolsUtils getResponseMsgWithDict:data]]];
     }
     }];


