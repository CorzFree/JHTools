//
//  JNetResponse.h

//
//  Created by 降瑞雪 on 2017/4/5.
//  Copyright © 2017年 HuiYuan.NET. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JNetPResult) {
    JNetPResultSuccess          = 1,    // 支付成功
    JNetPResultFail             = -1,   // 支付失败
    JNetPResultDealing          = 0,    //单据处理中
    JNetPResultCancel           = -2,   //取消支付
    JNetPResultError            = -3,   // 用户录入信息有误、等一般性错误，
    JNetPResultUnknown          = -4    //获取支付结果失败，当出现这种状态时，需要商户APP主动向商户服务器发起查询请求。
} ;

@interface JNetResponse : NSObject

@property (nonatomic,copy) NSString * message;
@property (nonatomic,assign) JNetPResult pResult;

@end
