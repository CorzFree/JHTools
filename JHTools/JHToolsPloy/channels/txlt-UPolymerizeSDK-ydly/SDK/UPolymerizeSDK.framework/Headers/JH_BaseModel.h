//
//  JH_BaseModel.h
//  PolymerizeSDK
//
//  Created by YuLing on 2017/11/22.
//  Copyright © 2017年 com.youguu.h5gameCenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JH_BaseModel : NSObject
#pragma mark - 对象转字典
- (NSDictionary *)dictionaryRepresentation;
#pragma mark - 字典转对象
- (id)initWithDict:(NSDictionary *)aDict;
@end
