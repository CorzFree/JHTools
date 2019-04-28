
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRequestForm : NSObject


+ (id)sharedInstance;

/**
 6.1.3	预下单接口
 
 @param service       接口类型（必填）
 @param out_trade_no  商户订单号（必填）
 @param device_info   设备号（非必填）
 @param server_name   区服（非必填）
 @param body          商品描述（必填）
 @param total_fee     总金额 (必填)
 @param trade_type    支付类型 (必填)
 @param notify_url    通知地址 (必填)
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
                       notify_url:(NSString*)notify_url;


@end
