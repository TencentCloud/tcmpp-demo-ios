//
//  MQQDatabase.h
//  MQQSecure
//
//  Created by SparkChen on 14-2-11.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <MQQComponents/MQQDBResultSet.h>

@interface MQQDatabase : NSObject {
    sqlite3 *_db;
    NSError *_lastError;
    BOOL _isCachedStatements;
}
@property(nonatomic,assign) BOOL isCachedStatements;  // 是否缓存数据库statement

/**
 *
 * 初始化，提供静态方法
 *
 * @param path : 创建SQLite数据库文件的路径
 *
 */
- (id)initWithPath:(NSString *)path;
+ (id)databaseWithPath:(NSString *)path;

/**
 * 打开数据库连接
 */
- (BOOL)open;

/**
 * 关闭数据库连接
 */
- (BOOL)close;

/**
 * 重启数据库连接
 */
- (BOOL)reopen;

/**
 *
 * 执行数据库的写操作, 除'SELECT'之外, 包括'CREATE', 'UPDATE', 'INSERT', 'COMMIT', 'DELETE'等
 *
 * @param  sqlString : sql语句，语句中的参数统一用'?'表示，并在可选参数...进行一一对应绑定
 * @param  ...      : 可选参数，对应sqlString中的'?'，传参必须是'NSString', 'NSNumber', 'NSDate', 'NSData', 'NSNull'对象
 * @return : 成功返回YES，失败返回NO，可以在 [self lastError] 查看详细失败信息
 *
 * e.g.
 * [db execUpdate:@"insert into test (a, b) values (?, ?)", @(123), @(456)];
 *
 */
- (BOOL)execUpdate:(NSString *)sqlString, ...;

/**
 *
 * 执行数据库的写操作, 除'SELECT'之外, 包括'CREATE', 'UPDATE', 'INSERT', 'COMMIT', 'DELETE'等
 *
 * @param  sqlString  : sql语句，语句中的参数统一用'?'表示，并在可选参数...进行一一对应绑定
 * @param  argsArray : 参数数组，对应sqlString中的'?'
 * @return : 成功返回YES，失败返回NO，可以在 [self lastError] 查看详细失败信息
 *
 * e.g.
 * NSArray *array = [NSArray arrayWithObjects:@(123), @(456), nil];
 * [db execUpdate:@"insert into test (a, b) values (?, ?);" withArgumentsInArray:array];
 *
 */
- (BOOL)execUpdate:(NSString *)sqlString withArgumentsInArray:(NSArray *)argsArray;

/**
 *
 * 执行数据库的读操作，包括'SELECT'.
 *
 * @param  sqlString : sql语句，语句中的参数统一用'?'表示，并在可选参数...进行一一对应绑定
 * @param  ...      : 可选参数，对应sqlString中的'?'，传参必须是'NSString', 'NSNumber', 'NSDate', 'NSData', 'NSNull'对象
 * @return : 成功返回'MQQDBResultSet'对象，失败返回'nil'，可以在 [self lastError] 查看详细失败信息
 *
 * e.g.
 * MQQDBResultSet *rs = [db executeQuery:@"select a, b from test"];
 *
 */
- (MQQDBResultSet *)execQuery:(NSString *)sqlString, ...;

/**
 *
 * 执行数据库的读操作，包括'SELECT'.
 *
 * @param  sqlString  : sql语句，语句中的参数统一用'?'表示，并在可选参数...进行一一对应绑定
 * @param  argsArray : 参数数组，对应sqlString中的'?'
 * @return : 成功返回'MQQDBResultSet'对象，失败返回'nil'，可以在 [self lastError] 查看详细失败信息
 *
 * e.g.
 * NSArray *array = [NSArray arrayWithObjects:@(1), @(2), @(3), nil];
 * MQQDBResultSet *rs = [db executeQuery:@"select a, b from test where a in (?,?,?);" withArgumentsInArray:array];
 *
 */
- (MQQDBResultSet *)execQuery:(NSString *)sqlString withArgumentsInArray:(NSArray *)argsArray;

/**
 * 是否有打开的查询结果集在使用
 */
- (BOOL)hasOpenResultSet;

/**
 * 外部打开的查询结果集已经关闭
 *
 * @param rs : 已经关闭的查询结果集
 *
 */
- (void)resultSetDidClose:(MQQDBResultSet *)rs;

/**
 * 清除所有的缓存stmt（!!!避免在外部打开结果集时进行清理，将导致结果集中stmt被清!!!）
 */
- (void)clearCachedStatements;

/**
 * 关闭所有外部打开的结果集
 */
- (void)closeAllOpenResultSets;

/**
 * 上次的错误信息
 *
 * @return : 返回'NSError'如果上次执行sql语句有错误发生，否则为nil
 *
 */
- (NSError *)lastError;

/**
 * 返回SQLite句柄
 *
 * @return : sqlite3指针
 */
- (sqlite3 *)sqliteHandle;

/**
 * 处理SQLite错误（生成并保存错误日志）
 */
- (void)handleSqliteError;

/**
 * 返回上个SQLite语句操作改变的行数，包括'INSERT', 'UPDATE', or 'DELETE'（see [sqlite3_changes()]）
 *
 * @return : 上次SQLite语句操作影响的行数
 */
- (int)changes;

/**
 * 返回最后1次插入的行数id
 */
- (long long)lastInsertRowId;

@end
