//
//  SMPCQuickSDKGameRoleInfo.h
//  SMPCQuickSDK
//
//

#import <Foundation/Foundation.h>

@interface SMPCQuickSDKGameRoleInfo : NSObject
@property (nonatomic,copy) NSString *serverId;         //服务器Id，必填
@property (nonatomic,copy) NSString *serverName;       //服务器名称，必填
@property (nonatomic,copy) NSString *gameRoleName;     //角色名，必填
@property (nonatomic,copy) NSString *gameRoleID;       //角色ID，必填
@property (nonatomic,copy) NSString *gameUserBalance;  //玩家虚拟货币余额，必填，可随意
@property (nonatomic,copy) NSString *vipLevel;         //玩家vip等级，必填，可随意
@property (nonatomic,copy) NSString *gameUserLevel;    //玩家等级，必填，可随意
@property (nonatomic,copy) NSString *partyName;        //公会名称，必填，可随意
@end
