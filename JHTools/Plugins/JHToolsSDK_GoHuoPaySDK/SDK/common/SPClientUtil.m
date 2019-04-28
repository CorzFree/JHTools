
//
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import "SPClientUtil.h"
#define PREFIX_STRING_FOR_ELEMENT @"@" //From XMLReader



@interface SPClientUtil ()
@property (strong, nonatomic) NSMutableArray* nodes;


@property (nonatomic,copy) NSString* xml;

@property (strong, nonatomic) NSMutableArray* treeNodes;

@property (assign,nonatomic) BOOL isRoot;

@property (nonatomic,copy) NSString* passDict;

@property (assign,nonatomic) BOOL withHeader;

@end;

//
//@private
//NSMutableArray* nodes;
//NSString* xml;
//NSMutableArray* treeNodes;
//BOOL isRoot;
//NSString* passDict;
//BOOL withHeader;

@implementation SPClientUtil

-(void)serialize:(id)root
{
    if([root isKindOfClass:[NSArray class]])
    {
        int mula = (int)[root count];
        mula--;
        [self.nodes addObject:[NSString stringWithFormat:@"%i",(int)mula]];
        
        for(id objects in root)
        {
            if ([[self.nodes lastObject] isEqualToString:@"0"] || [self.nodes lastObject] == NULL || ![self.nodes count])
            {
                [self.nodes removeLastObject];
                [self serialize:objects];
            }
            else
            {
                [self serialize:objects];
                if(!self.isRoot)
                    self.xml = [self.xml stringByAppendingFormat:@"</%@><%@>",[self.treeNodes lastObject],[self.treeNodes lastObject]];
                else
                    self.isRoot = FALSE;
                int value = [[self.nodes lastObject] intValue];
                [self.nodes removeLastObject];
                value--;
                [self.nodes addObject:[NSString stringWithFormat:@"%i",(int)value]];
            }
        }
    }
    else if ([root isKindOfClass:[NSDictionary class]])
    {
        for (NSString* key in root)
        {
            if(!self.isRoot)
            {
                //                    NSLog(@"We came in");
                [self.treeNodes addObject:key];
                self.xml = [self.xml stringByAppendingFormat:@"<%@>",key];
                [self serialize:[root objectForKey:key]];
                self.xml =[self.xml stringByAppendingFormat:@"</%@>",key];
                [self.treeNodes removeLastObject];
            } else {
                self.isRoot = FALSE;
                [self serialize:[root objectForKey:key]];
            }
        }
    }
    else if ([root isKindOfClass:[NSString class]] || [root isKindOfClass:[NSNumber class]] || [root isKindOfClass:[NSURL class]])
    {
        //            if ([root hasPrefix:"PREFIX_STRING_FOR_ELEMENT"])
        //            is element
        //            else
        self.xml = [self.xml stringByAppendingFormat:@"%@",root];
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.xml = @"";
        if (self.withHeader)
            self.xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
        self.nodes = [[NSMutableArray alloc] init];
        self.treeNodes = [[NSMutableArray alloc] init];
        self.isRoot = YES;
        self.passDict = [[dictionary allKeys] lastObject];
        self.xml = [self.xml stringByAppendingFormat:@"<%@>\n",self.passDict];
        [self serialize:dictionary];
    }
    
    return self;
}
- (id)initWithDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header {
   self.withHeader = header;
    self = [self initWithDictionary:dictionary];
    return self;
}

-(void)dealloc
{
    //    [xml release],nodes =nil;
    self.nodes = nil;
    self.treeNodes = nil;
  
}

-(NSString *)getXML
{
    self.xml = [self.xml stringByReplacingOccurrencesOfString:@"</(null)><(null)>" withString:@"\n"];
    self.xml = [self.xml stringByAppendingFormat:@"\n</%@>",self.passDict];
    return self.xml;
}

+(NSString *)XMLStringFromDictionary:(NSDictionary *)dictionary
{
    if (![[dictionary allKeys] count])
        return NULL;
    SPClientUtil* fromDictionary = [[SPClientUtil alloc]initWithDictionary:dictionary];
    return [fromDictionary getXML];
}

+ (NSString *) XMLStringFromDictionary:(NSDictionary *)dictionary withHeader:(BOOL)header {
    if (![[dictionary allKeys] count])
        return NULL;
    SPClientUtil* fromDictionary = [[SPClientUtil alloc]initWithDictionary:dictionary withHeader:header];
    return [fromDictionary getXML];
}

+(BOOL)XMLDataFromDictionary:(NSDictionary *)dictionary toStringPath:(NSString *) path  Error:(NSError **)error
{
    
    SPClientUtil* fromDictionary = [[SPClientUtil alloc]initWithDictionary:dictionary];
    [[fromDictionary getXML] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:error];
    if (error)
        return FALSE;
    else
        return TRUE;
    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  字段转换成json字符串
 *
 *  @param dict <#dict description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)dictToJsonStr:(NSDictionary *)dict{
    
    NSString *jsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"json data:%@",jsonString);
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    return jsonString;
}

@end
