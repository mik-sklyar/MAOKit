//  Foundation+modernObjC.h

#ifndef __IPHONE_6_0

#import <Foundation/Foundation.h>

@interface NSDictionary(modernObjC)
- (id)objectForKeyedSubscript:(id)key;
@end

@interface NSMutableDictionary(modernObjC)
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
@end

@interface NSArray(modernObjC)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface NSMutableArray(modernObjC)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end

#endif