
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import "SPRequestForm.h"
#import "NSDictionary+SPUtilsExtras.h"
#import "SPConst.h"

@implementation SPRequestForm


+ (id)sharedInstance
{
    static SPRequestForm *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}


/**
 6.1.3	预下单接口
 @return 字典
 */
- (NSDictionary*)sp_pay_gateway:(NSString*)service
                            appid:(NSString*)appid
                           openid:(NSString*)openid
                     out_trade_no:(NSString*)out_trade_no
                      device_info:(NSString*)device_info
                             body:(NSString*)body
                        total_fee:(NSInteger)total_fee
                       trade_type:(NSString*)trade_type
                      server_name:(NSString*)server_name
                           remark:(NSString*)remark
                       notify_url:(NSString*)notify_url{
    
    NSDictionary *mustInfo = @{@"service":service,
                               @"appid":appid,
                               @"openId":openid,
                               @"attach":out_trade_no,
                               @"mch_id":body,
                               @"total_fee":@(total_fee),
                               @"cash_fee":@(total_fee),
                               @"trade_type":trade_type,
                               @"server_name":server_name,
                               @"remark":remark,
                               @"url":notify_url};
    
    NSMutableDictionary *postInfo = [[NSMutableDictionary alloc]initWithDictionary:mustInfo];
    //如果非必填的参数没有传入，则不将该Key传入表单
    //[postInfo safeSetValue:@"appid" val:appIdVal];
    //[postInfo safeSetValue:@"" val:@"ios123"];
    [postInfo safeSetValue:@"bank_type" val:@"wft_ios"];
    return [self packingRequestForm:postInfo];
};

/**
 *  封装请求表单
 *
 *  @param postInfo <#postInfo description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary*)packingRequestForm:(NSDictionary*)postInfo{
    
    //生成请求签名
    NSString *signString = [postInfo spRequestSign:appSignVal];
    NSAssert(signString, @"SDK Sign must not be nil.");
    
    NSMutableDictionary *requestForm = [[NSMutableDictionary alloc]initWithDictionary:postInfo];
    [requestForm setObject:signString forKey:@"sign"];
    
    return [requestForm copy];
}
@end
