//
//  XLoginResult.h
//  XSDK
//
//  Created by user on 2017/11/27.
//  Copyright © 2017年 xsdk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLoginResult : NSObject

@property (nonatomic, strong) NSString* username;       //用户名
@property (nonatomic, strong) NSString* userId;         //用户id
@property (nonatomic, strong) NSString* accessToken;    //token

-(id)initWithUserId:(NSString*)userId username:(NSString*)username accessToken:(NSString*)accessToken;

@end
