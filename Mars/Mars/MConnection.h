//
//  CTQuery.m
//  Mars
//
//  Created by Matt Ronge on 2/24/13.
//  Copyright (c) 2013 Central Atomics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

#ifdef DEBUG
#define LOG_SQL 1
#else
#define LOG_SQL 0
#endif

#define kNoPk -1

@class MQuery;

@interface MConnection : NSObject
@property (nonatomic, assign, readonly) sqlite3 *dbHandle;
@property (nonatomic, assign, readonly) int64_t lastInsertRowId;
@property (nonatomic) NSTimeInterval maxBusyRetryTimeInterval;
@property (nonatomic) NSTimeInterval startBusyRetryTime;

- (id)init;
- (id)initWithPath:(NSString *)path;
- (BOOL)open;
- (void)close;
- (BOOL)exec:(NSString *)sql error:(NSError **)error;
- (int64_t)executeUpdate:(MQuery *)query error:(NSError **)error;
- (NSArray *)executeQuery:(MQuery *)query error:(NSError **)error;
- (id)executeRawQuery:(NSString *)rawQuery error:(NSError **)error;
- (BOOL)beginTransaction:(NSError **)error;
- (BOOL)commit:(NSError **)error;
- (BOOL)rollback:(NSError **)error;
@end
