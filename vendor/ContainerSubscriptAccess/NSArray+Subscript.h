//
//  NSArray+Subscript.h
//
//  Created by Alexander Ney on 12.08.12.
//  Copyright (c) 2012 Alexander Ney. All rights reserved.
//

#if !defined(__IPHONE_6_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import <Foundation/Foundation.h>

@interface NSArray (Subscript)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface NSMutableArray (Subscript)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
@end

#endif
