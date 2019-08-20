//
//  X_GameDataModel.h
//  XSDK
//
//  Created by 杨波 on 2017/11/2.
//  Copyright © 2017年 xsdk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GameDataModelOPType)
{
    OP_CREATE_ROLE = 1,
    OP_ENTER_GAME,
    OP_LEVEL_UP,
    OP_EXIT
};

@interface XGameExtraData : NSObject
@property (nonatomic,assign) int opType;
@property (nonatomic,strong) NSString *serverID;
@property (nonatomic,strong) NSString *serverName;
@property (nonatomic,strong) NSString *roleID;
@property (nonatomic,strong) NSString *roleName;
@property (nonatomic,strong) NSString *roleLevel;
@property (nonatomic,strong) NSString *vip;

@end
