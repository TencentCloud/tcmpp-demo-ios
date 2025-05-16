//
//  MQQDBResultSet.h
//  MQQSecure
//
//  Created by SparkChen on 14-2-12.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MQQDBStatement;
@class MQQDatabase;

@interface MQQDBResultSet : NSObject {
    MQQDBStatement *_statement;
    MQQDatabase    *_mDB;
    NSError *_error;
}
@property(nonatomic,retain) MQQDBStatement *statement; // 关联的查询stmt

/**
 *
 * 初始化，提供静态方法
 *
 * @param stmt : 结果集的stmt
 * @param db   : 结果集的对应数据库
 *
 */
+ (id)resultSetWithStatement:(MQQDBStatement *)stmt database:(MQQDatabase *)db;
- (id)initWithStatement:(MQQDBStatement *)stmt database:(MQQDatabase *)db;

/**
 *
 * 查找结果集中的下一行结果
 *
 * @return 返回YES如果成功找到一行结果，下一行已经没有结果或者查找过程出错返回NO
 *
 */
- (BOOL)next;

/**
 * 返回结果集中的当前一行结果字典
 *
 * e.g.
 * if ([self next]) {
 *     NSDictionary *dict = [self resultRowDictionary];
 * }
 *
 */
- (NSDictionary *)resultRowDictionary;

/**
 * 返回结果集中的所有行结果（表），数组包多行字典。异常返回nil，see－［self lastError］
 */
- (NSArray *)resultArray;

/**
 * 根据列索引，返回当前行的对应类型值，从0开始
 *
 * e.g.
 * if ([self next]) {
 *     int a = [self intForColumnIndex:0];
 * }
 *
 */
- (int)intForColumnIndex:(int)columnIndex;
- (long long)longLongForColumnIndex:(int)columnIndex;
- (double)doubleForColumnIndex:(int)columnIndex;
- (BOOL)boolForColumnIndex:(int)columnIndex;
- (NSData *)dataForColumnIndex:(int)columnIndex;
- (NSString *)stringForColumnIndex:(int)columnIndex;
- (id)objectForColumnIndex:(int)columnIndex;

/**
 * 根据列名称，返回当前行的对应类型值
 *
 * e.g.
 * if ([self next]) {
 *     int a = [self intForColumnName:@"a"];
 * }
 *
 */
- (int)intForColumnName:(NSString *)columnName;
- (long long)longLongForColumnName:(NSString *)columnName;
- (double)doubleForColumnName:(NSString *)columnName;
- (BOOL)boolForColumnName:(NSString *)columnName;
- (NSData *)dataForColumnName:(NSString *)columnName;
- (NSString *)stringForColumnName:(NSString *)columnName;
- (id)objectForColumnName:(NSString *)columnName;

/**
 * 关闭结果集，释放stmt并置空数据库引用
 * !!!业务查询完注意调用关闭结果集，确保及时释放资源!!!
 */
- (void)close;

/**
 * 上次的错误信息
 *
 * @return : 返回‘NSError’如果上次查询结果集有错误发生，否则为nil
 *
 */
- (NSError *)lastError;

@end
