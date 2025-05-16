//
//  MQQDatabase+Util.h
//  MQQSecure
//
//  Created by SparkChen on 14-2-11.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <MQQComponents/MQQDatabase.h>

@interface MQQDatabase (Util)

/**
 * 将objc绑定到指定statement的指定columnIndex
 */
+ (void)bindObject:(id)obj toColumn:(int)columnIndex inStatement:(sqlite3_stmt *)pStmt;

/**
 * SQLite语句中字符串，单引号用双引号替换
 */
+ (NSString *)sqlString:(NSString *)string;

@end
