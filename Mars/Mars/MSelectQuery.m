//
//  CTSelectQuery.m
//  Mars
//
//  Created by Matt Ronge on 2/24/13.
//  Copyright (c) 2013 Central Atomics. All rights reserved.
//

#import "MSelectQuery.h"
#import "MQuery+Private.h"

@implementation MSelectQuery

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
        NSMutableArray *columns = [NSMutableArray array];
        for (NSString *column in self.columns) {
            [columns addObject:[self quote:column]];
        }
        rowStr = [columns componentsJoinedByString:@", "];
    } else {
        rowStr = @"*";
    }
    
    NSMutableString *str = nil;
    if (self.where) {
        str = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@", rowStr, [self tableString], [self whereString]];
    } else {
        str = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@", rowStr, [self tableString]];
    }
    
    if (self.orderBy) {
        [str appendFormat:@" ORDER BY %@ DESC", [self quote:self.orderBy]];
    }
    return str;
}

- (BOOL)modifies {
    return NO;
}

- (NSString *)tableString {
    if ([self.table isKindOfClass:[NSString class]]) {
        // Plain old string format "tablename"
        return [self quote:self.table];
    } else if ([self.table isKindOfClass:[NSArray class]]) {
        NSArray *tableInfos = (NSArray *)self.table;
        if (tableInfos.count == 2 && [tableInfos[0] isKindOfClass:[NSString class]] && [tableInfos[1] isKindOfClass:[NSString class]]) {
            // Is of the format ["table" "alias"]
            NSArray *info = (NSArray *)tableInfos[0];
            return [self asString:tableInfos[0] alias:tableInfos[1]];
        } else if (tableInfos.count > 0) {
            NSMutableArray *asStatements = [NSMutableArray array];
            for (id obj in tableInfos) {
                NSAssert([obj isKindOfClass:[NSArray class]], @"Must be a NSArray!");
                NSArray *info = (NSArray *)obj;
                [asStatements addObject:[self asString:info[0] alias:info[1]]];
            }
            return [asStatements componentsJoinedByString:@", "];
        }
    }
    NSAssert(false, @"The table must be a string or an array like [tablename alias], or [[table1 t1], [table2 t2]]");
}

- (NSString *)asString:(NSString *)table alias:(NSString *)alias {
    return [NSString stringWithFormat:@"%@ AS %@", [self quote:table], [self quote:alias]];
}
@end
