//
//  PlayerInfo.h
//
//  Created by zhujin zhujin on 17/8/18.
//  Copyright © 2017年 mak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerInfo : NSObject
@property (nonatomic, copy) NSString *gameService;//区服名
@property (nonatomic, copy) NSString *gameServiceId;//区服id
@property (nonatomic, copy) NSString *playerLevel;//用户等级
@property (nonatomic, copy) NSString *playerName;//用户名

@end
