//
//  MDatabase+AsyncAdditions.m
//  VMail
//
//  Created by Matt Ronge on 04/01/13.
//  Copyright (c) 2013 Central Atomics Inc. All rights reserved.
//

#import "MDatabase+AsyncAdditions.h"
#import "MQuery.h"

@implementation MDatabase (AsyncAdditions)
- (void)queries:(NSArray *)queries completionBlock:(void (^)(NSError *err, NSArray *results))completionBlock {
    __block int finished = 0;
    NSMutableArray *results = [NSMutableArray array];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused"
    for (MQuery *query in queries) {
#pragma clang diagnostic pop
        [results addObject:[NSNull null]]; // Acts as a placeholder
    }


    for (MQuery *query in queries) {
        [self query:query completionBlock:^(NSError *err, id result) {
            if (err) {
                completionBlock(err, nil);
                return;
            }
            
            if (!result) {
                NSError *error = [NSError errorWithDomain:@"MDatabase"
                                                     code:-1
                                                 userInfo:@{NSLocalizedDescriptionKey: @"query result is nil"}];
                completionBlock(error, nil);
                return;
            }

            NSUInteger pos = [queries indexOfObject:query];
            results[pos] = result;

            finished++;
            if (finished == queries.count) {
                completionBlock(nil, results);
            }
        }];
    }
}
@end
