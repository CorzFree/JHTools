//
//  SPClientFintechStateModel.h
//  SPSDK
//
//  Created by wongfish on 15/6/11.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwiftFintechClientConstEnum.h"

@interface SwiftFintechClientFintechStateModel : NSObject

@property (nonatomic,assign) SPClientConstEnumFintechState fintechState;

/**
 *  提示消息
 */
@property (nonatomic,copy) NSString *messageString;


@end
