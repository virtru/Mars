//
//  CTQuery+Private.h
//  Mars
//
//  Created by Matt Ronge on 2/24/13.
//  Copyright (c) 2013 Central Atomics. All rights reserved.
//

#import "CTQuery.h"

@interface CTQuery ()
@property (nonatomic, strong) NSString *table;
@property (nonatomic, strong) NSArray *columns;
@property (nonatomic, strong) NSDictionary *where;

- (NSString *)sql;
- (NSArray *)bindings;
@end
