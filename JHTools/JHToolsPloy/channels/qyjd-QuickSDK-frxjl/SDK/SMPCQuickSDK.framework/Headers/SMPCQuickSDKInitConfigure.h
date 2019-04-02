//
//  SMPCQuickSDKInitConfigure.h
//  SMPCQuickSDK
//
//

#import <Foundation/Foundation.h>



#pragma mark -
#pragma mark 初始化配置

@interface SMPCQuickSDKInitConfigure : NSObject
@property (nonatomic, copy) NSString *productCode;  //QuickSDK提供的 product_code
@property (nonatomic, copy) NSString *productKey;   //QuickSDK提供的 product_token
@end
