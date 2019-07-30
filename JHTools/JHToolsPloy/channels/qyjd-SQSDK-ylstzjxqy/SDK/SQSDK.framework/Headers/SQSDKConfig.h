//
//  SQSDKConfig.h
//  SQSDK
//
//  Created by Kaymin on 2017/6/13.
//  Copyright © 2017年 SQSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQSDKConfig : NSObject

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productKey;
@property (nonatomic, copy) NSString *gameKey;
/// 是否自动打开登录功能
@property (nonatomic, assign) BOOL autoOpenLoginPage;

@end
