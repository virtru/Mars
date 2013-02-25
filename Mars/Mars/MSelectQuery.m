//
//  CTSelectQuery.m
//  Mars
//
//  Created by Matt Ronge on 2/24/13.
//  Copyright (c) 2013 Central Atomics. All rights reserved.
//

#import "MSelectQuery.h"
#import "MQuery+Private.h"
#import "NSDictionary+Mars.h"

@implementation MSelectQuery {
}
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MSelectQuery *query = [[MSelectQuery alloc] init];
    query.table = self.table;
    query.columns = self.columns;
    query.where = self.where;
    return query;
}

- (NSString *)sql {
    NSAssert(self.table, nil);
    
    NSString *rowStr = nil;
    if (self.columns) {
        rowStr = [self.columns componentsJoinedByString:@", "];
    } else {
        rowStr = @"*";
    }
    
    if (self.where) {
        NSMutableArray *whereExprs = [NSMutableArray array];
        for (NSString *column in [self.where sortedKeys]) {
            [whereExprs addObject:[column stringByAppendingString:@"=?"]];
        }
        NSString *whereExprStr = [whereExprs componentsJoinedByString:@" AND "];
        
        return [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", rowStr, self.table, whereExprStr];
    } else {
        return [NSString stringWithFormat:@"SELECT %@ FROM %@", rowStr, self.table];
    }
}
@end
