//
//  NSDictionary+Subscript.m
//
//  Created by Alexander Ney on 12.08.12.
//  Copyright (c) 2012 Alexander Ney. All rights reserved.
//

#if !defined(__IPHONE_6_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import "NSDictionary+Subscript.h"

@implementation  NSDictionary (Subscript)

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}
@end

@implementation  NSMutableDictionary (Subscript)
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    [self setObject:obj forKey:key];
}
@end

#endif
