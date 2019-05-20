#import <LBSDK/LBSDK.h>
#import "LBSDK+role.h"
@interface LBSDK (role)
@property (nonatomic, strong)NSURLSessionDataTask *roleCreateTask;
@property (nonatomic, strong)NSURLSessionDataTask *roleLoginTask;
@property (nonatomic, strong)NSURLSessionDataTask *roleUpgradeTask;
- (void)roleCreationNotification:(LBRoleInfoConfigure *)roleConfigure;
- (void)roleLoginNotification:(LBRoleInfoConfigure *)roleConfigure;
- (void)roleUpdateNotification:(LBRoleInfoConfigure *)roleConfigure;
@end
@interface LBRoleInfoConfigure : NSObject
@property (nonatomic, copy) NSString *playerId;
@property (nonatomic, copy) NSString *playerName;
@property (nonatomic, copy) NSString *playerLevel;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *serverId;
@property (nonatomic, copy) NSString *serverName;
@property (nonatomic, copy) NSString *eventTime;
@property (nonatomic, copy) NSString *isTest;
@end
