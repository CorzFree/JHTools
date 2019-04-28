#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GohuoClient : NSObject

+ (GohuoClient*)sharedInstance;

- (void)spTokenIDString:(NSString*)spTokenIDString
fintechServicesString:(NSString*)fintechServicesString;
@end

