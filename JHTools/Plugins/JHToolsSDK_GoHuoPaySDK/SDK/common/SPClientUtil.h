//
//  FintechClientXMLWriter.h
//  FintechSDK
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRequestForm.h"

@interface SPClientUtil : NSObject

+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary;
+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header;
+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSString *)dictToJsonStr:(NSDictionary *)dict;
@end
