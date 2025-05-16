//
//  MQQDBStatement.h
//  MQQSecure
//
//  Created by SparkChen on 14-2-12.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MQQDBStatement : NSObject {
    sqlite3_stmt *_stmt;
    NSString *_sqlString;
}
@property(nonatomic,assign) sqlite3_stmt *stmt; // 封装的sqlite3_stmt指针
@property(nonatomic,copy) NSString *sqlString;  // 对应stmt的SQLite语句

/**
 * 重置stmt，下次复用（reset）
 */
- (void)reset;

/**
 * 关闭stmt（finalize）
 */
- (void)close;

@end
