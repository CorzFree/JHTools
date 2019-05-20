#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LBInitConfigure;

@class LBRoleInfoConfigure;

@interface LBSDK : NSObject
@property (nonatomic ,assign) NSInteger floating_window;

@property (nonatomic, copy) NSString *floating_window_features;

@property (nonatomic, assign) UIInterfaceOrientation platformOrientation;

@property (nonatomic, readonly,assign) BOOL isPlatformAutoRotate;

@property (nonatomic, assign) BOOL isShowPanel;

@property (nonatomic, assign) BOOL isShowPaLBRootScrollViewnel;

@property (nonatomic, copy) NSString *qq;

@property (nonatomic, copy) NSString *number;

+ (LBSDK *)shareInstance;

- (void)setAppId:(NSString *)appId;

- (void)setChannel:(NSString *)channel;

- (void)LBSDKInit;

- (void)LBSDKLogin;

- (void)LBSDKLogout;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

- (void)LBHideAssisTiveIcon:(BOOL)hide;

- (void)LBClosePanel;

- (void)deleteWebCache;

@end

@interface LBInitConfigure : NSObject

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, copy) NSString *appSecret;

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *expansion;
@property (nonatomic, retain) NSData *deviceToken;
@property (nonatomic , copy) NSString* userAgent;
+ (LBInitConfigure *)shareInstance;
@end
