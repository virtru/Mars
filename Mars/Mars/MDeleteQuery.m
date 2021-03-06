//
//  MDeleteQuery.m
//  Mars
//
//  Created by Matt Ronge on 2/24/13.
//  Copyright (c) 2013 Central Atomics. All rights reserved.
//

#import "MDeleteQuery.h"
#import "MQuery+Private.h"

@implementation MDeleteQuery
- (id)copyWithZone:(NSZone *)zone {
    MDeleteQuery *query = [[[self class] alloc] init];
    query.table = self.table;
    query.where = self.where;
    return query;
}

- (NSString *)sql {
    NSAssert(self.table, nil);
    
    if (self.where) {
        return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", [self quote:self.table], [self whereString]];
    } else {
        return [NSString stringWithFormat:@"DELETE FROM %@", [self quote:self.table]];
    }
}

// Have to do this to get the compiler to stop complaining
- (instancetype)where:(NSDictionary *)expressions {
    return (MDeleteQuery *)[super where:expressions];
}
@end
