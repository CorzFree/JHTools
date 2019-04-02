//
//  TQWSDKPayOrderInfo.h
//  tao7wan
//
//  Created by wanggp on 2018/8/10.
//  Copyright © 2018年 wanggp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQWSDKPayOrderInfo : NSObject


@property (strong, nonatomic) NSString *trade_id; // (必要参数)                - 开发商提交订单号
@property (strong, nonatomic) NSString *provider; //  (必要参数)                - 渠道标识
@property (strong, nonatomic) NSString *provider_config;// (可选参数)         - 渠道配置信息JSON格式
@property (strong, nonatomic) NSString *developerurl;// (必要参数)            - 开发商的回调地址，用来接收支付结果的回调地址
@property (strong, nonatomic) NSString *amount;// (可选参数)                  - 交易金额，以“元”为单位，必须大于零
@property (strong, nonatomic) NSString *currency;// (可选参数)                - 货币代码，详情参考附录 A1. 货币代码（Currency Codes）。不填则默认为 CNY
@property (strong, nonatomic) NSString *amount_in_currency;// (可选参数)      - 交易金额，以 currency 指定的货币为单位，必须大于零。
@property (strong, nonatomic) NSString *product_name ;//(必要参数)            - 商品名称，最长50位。
@property (strong, nonatomic) NSString *game_server_id;// (必要参数)          - 游戏服务器id，最长10位
@property (strong, nonatomic) NSString *extra_data;// (必要参数)              - 额外参数，其中包含：
@property (strong, nonatomic) NSString *private_info;// (可选参数)        - CP 提供的文本信息，将在回调中原值返回
@property (strong, nonatomic) NSString *role_id ;//(必要参数)             - 用户角色ID


@end
