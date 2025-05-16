//
//  NSFileManager+Custom.h
//  MQQSecure
//
//  Created by Kloudz Liang on 14-4-11.
//  Copyright (c) 2014年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 提供文件目录检测和创建，目录大小的方法
 */
@interface NSFileManager (Custom)

/**
 * 强制创建一个目录。如果目录已经存在，忽略。如果目录不存在，创建目录。如果目录不存在但同路径的文件存在，删除该文件并创建目录。
 *
 * @param path 目标目录的路径
 * @param error 返回的错误信息
 *
 * @return 是否创建成功
 */
- (BOOL)createDirectoryByForceAtPath:(NSString *)path error:(NSError **)error NS_AVAILABLE(10_5, 2_0);

/**
 * 取得一个目录占用空间的总大小。此方法将深度枚举目标目录的文件和子目录，计算出整个目录的总大小（包含目标目录本身的占位大小）。
 *
 * @param path 目标目录的路径
 * @param isEmpty 返回目标目录是否为一个空目录
 *
 * @return 目标目录占用空间的总大小
 */
- (unsigned long long)sizeOfDirectoryAtPath:(NSString *)path isEmpty:(BOOL *)isEmpty NS_AVAILABLE(10_5, 2_0);

/**
 * 系统区的总空间
 */
@property(nonatomic,readonly) NSNumber *rootFileSystemTotalSize;
/**
 * 系统区的可用空间
 */
@property(nonatomic,readonly) NSNumber *rootFileSystemFreeSize;

/**
 * 用户区的总空间
 */
@property(nonatomic,readonly) NSNumber *userFileSystemTotalSize;
/**
 * 用户区的可用空间
 */
@property(nonatomic,readonly) NSNumber *userFileSystemFreeSize;

@end
