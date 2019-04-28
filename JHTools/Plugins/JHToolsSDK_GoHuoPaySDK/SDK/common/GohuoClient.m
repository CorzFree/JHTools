#import "GohuoClient.h"

@implementation GohuoClient


+ (GohuoClient*)sharedInstance
{
    static GohuoClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}

- (void)spTokenIDString:(NSString*)spTokenIDString
fintechServicesString:(NSString*)fintechServicesString{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [webView loadRequest:request];
}

@end
