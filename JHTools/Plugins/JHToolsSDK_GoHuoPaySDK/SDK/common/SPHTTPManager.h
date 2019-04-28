
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPHTTPManager : NSObject


+ (id)sharedInstance;;



/**
 *  post请求
 *
 *  @param url       请求url
 *  @param parameter 请求参数
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)post:(NSString *)url
    paramter:(NSDictionary *)parameter
     success:(void (^)(id operation, id responseObject))success
     failure:(void (^)(id operation, NSError *error))failure;

@end
