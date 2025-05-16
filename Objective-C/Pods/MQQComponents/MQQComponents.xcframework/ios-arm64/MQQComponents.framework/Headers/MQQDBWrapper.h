//
//  MQQDBWrapper.h
//  MQQSecure
//
//  Created by SparkChen on 14-2-13.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQQComponents/MQQDatabase.h>

typedef NS_ENUM(NSInteger, DBJournalMode) {
    DBJournalModeDelete   = 0,  // DELETE=deault
    DBJournalModeWal      = 1,  // WAL
    DBJournalModeTruncate = 2,  // TRUNCATE
    DBJournalModePersist  = 3,  // PERSIST
    DBJournalModeMemory   = 4,  // MEMORY
    DBJournalModeOff      = 5,  // OFF
};
// !!!warnning : 沙箱app，启动了wal模式的数据库连接，在进入后台模式进行读写操作，将随机产生Crash。勿在后台启动wal模式的数据库操作。!!!

@interface MQQDBWrapper : NSObject {
    MQQDatabase *_mDB;
    dispatch_queue_t _queue; // 执行队列
    DBJournalMode _journalMode;
    NSUInteger _walAutoCheckPointLogPages;
}

@property(nonatomic,assign) BOOL isCachedStatements; // 是否缓存stmt，default=NO
@property(nonatomic,assign) NSUInteger walAutoCheckPointLogPages; // wal模式自动checkpoint的日志数，default=1000

/**
 *
 * 初始化，提供静态方法
 * @param path : 创建SQLite数据库文件的路径
 *
 */
- (id)initWithPath:(NSString *)path;
+ (id)databaseWrapperWithPath:(NSString *)path;

/**
 *
 * 在队列中执行数据库操作
 * @param block : 放入执行队列的block(中赋值变量必须加上__block)
 *
 * e.g.
 * __block NSArray *result = nil;
 * [dbw inDatabase:^(MQQDatabase *db) {
 *     MQQDBResultSet *rs = [db executeQuery:@"select a, b from test"]
 *     result = [rs resultArray];
 *     [rs close];
 * }];
 *
 */
- (void)inDatabase:(void (^)(MQQDatabase *db))block;

/**
 *
 * 在队列中执行数据库操作，采用事务模式
 * @param block : 放入执行队列的block(中赋值变量必须加上__block)
 *
 * e.g.
 * [dbw inTransaction:^(MQQDatabase *db, BOOL *rollback) {
 *     [db execUpdate:@"insert into test (a, b) values (?, ?)", @(1), @(2)];
 *     [db execUpdate:@"insert into test (a, b) values (?, ?)", @(3), @(4)];
 *
 *     if (sth. wrong) {
 *         *rollback = YES;
 *         return;
 *     }
 * }];
 */
- (void)inTransaction:(void (^)(MQQDatabase *db, BOOL *rollback))block;

/**
 *
 * 设置日志模式，default=DELETE（!!!在数据库开启后进行设置!!!）
 * @param journalMode : 日志模式，see－DBJournalMode
 *
 */
- (void)setJournalMode:(DBJournalMode)journalMode;

/**
 * WAL模式下主动checkpoint，see－［sqlite3_wal_checkpoint］（注意该方法并不会清空-wal文件，只有关闭数据库才会清空-wal文件）
 */
- (BOOL)walCheckPoint;

@end
