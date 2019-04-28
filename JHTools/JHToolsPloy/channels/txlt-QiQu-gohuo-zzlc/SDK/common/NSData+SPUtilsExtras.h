
//  Created by wongfish on 15/6/14.
//  Copyright (c) 2015年 wongfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SPUtilsExtras)

/**
 * Calculate an md5 hash using CC_MD5.
 *
 * @returns The md5 hash of this data.
 */

- (NSString *)md5Hash;

@end
