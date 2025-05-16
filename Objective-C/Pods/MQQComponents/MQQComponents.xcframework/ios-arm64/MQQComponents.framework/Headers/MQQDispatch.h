//
//  MQQDispatch.h
//  MQQSecure
//
//  Created by Kloudz Liang on 13-12-11.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

#ifndef MQQSecure_MQQDispatch_h
#define MQQSecure_MQQDispatch_h


/**
 * 如在queue内，直接调用
 * 如不在queue内，dispatch_async到queue
 */
FOUNDATION_EXPORT
void mqq_dispatch_to_queue(dispatch_queue_t queue, const void *key, dispatch_block_t block);

/**
 * 如在主线程内，直接调用
 * 如不在queue内，dispatch_async到主线程
 */
FOUNDATION_EXPORT
void mqq_dispatch_to_main_queue(dispatch_block_t block);

/**
 * 如在queue内，直接调用
 * 如不在queue内，dispatch_sync到queue
 */
FOUNDATION_EXPORT
void mqq_dispatch_sync_to_queue(dispatch_queue_t queue, const void *key, dispatch_block_t block);

/**
 * 如在主线程内，直接调用
 * 如不在queue内，dispatch_async到主线程
 */
FOUNDATION_EXPORT
void mqq_dispatch_sync_to_main_queue(dispatch_block_t block);

/**
 * void
 * mqq_dispatch_sync_from_async_wait(dispatch_block_t block);
 *
 * 把异步方法转为同步方法执行，并等待
 * 此方法将等待异步block执行，直到在异步block内执行 mqq_dispatch_sync_from_async_signal()，等待才会结束
 *
 * ========= Example =========
 *  mqq_dispatch_sync_from_async_wait(^{
 *      [someObject doAsyncWithCompletion:^{
 *          // Do something
 *          mqq_dispatch_sync_from_async_signal();
 *      }];
 *  });
 *  // Finish waiting
 */
FOUNDATION_EXPORT
void mqq_dispatch_sync_from_async_wait(dispatch_block_t block);

/**
 * void
 * mqq_dispatch_sync_from_async_signal(dispatch_block_t block);
 
 * 把异步方法转为同步方法执行，并结束 mqq_dispatch_sync_from_async_wait(block) 的等待
 * 此方法应当在 mqq_dispatch_sync_from_async_wait(block) 的block内执行
 */
FOUNDATION_EXPORT
void mqq_dispatch_sync_from_async_signal(void);


#define mqq_dispatch_sync_from_async_wait(block) \
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); \
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block); \
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); \
    dispatch_release(semaphore);

#define mqq_dispatch_sync_from_async_signal() \
    dispatch_semaphore_signal(semaphore);

#define mqq_dispatch_to_queue mqq_dispatch_to_queue
#define mqq_dispatch_to_main_queue mqq_dispatch_to_main_queue
#define mqq_dispatch_sync_to_queue mqq_dispatch_sync_to_queue
#define mqq_dispatch_sync_to_main_queue mqq_dispatch_sync_to_main_queue



#endif
