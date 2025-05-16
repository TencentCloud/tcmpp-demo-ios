/**
 Copyright 2018 Google Inc. All rights reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at:

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "TFBLPromise.h"

NS_ASSUME_NONNULL_BEGIN

/** The default number of retry attempts is 1. */
FOUNDATION_EXTERN NSInteger const TFBLPromiseRetryDefaultAttemptsCount NS_REFINED_FOR_SWIFT;

/** The default delay interval before making a retry attempt is 1.0 second. */
FOUNDATION_EXTERN NSTimeInterval const TFBLPromiseRetryDefaultDelayInterval NS_REFINED_FOR_SWIFT;

@interface TFBLPromise<Value>(RetryAdditions)

typedef id __nullable (^TFBLPromiseRetryWorkBlock)(void) NS_SWIFT_UNAVAILABLE("");
typedef BOOL (^TFBLPromiseRetryPredicateBlock)(NSInteger, NSError *) NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise that fulfills with the same value as the promise returned from `work`
 block, which executes asynchronously, or rejects with the same error after all retry attempts have
 been exhausted. Defaults to `TFBLPromiseRetryDefaultAttemptsCount` attempt(s) on rejection where the
 `work` block is retried after a delay of `TFBLPromiseRetryDefaultDelayInterval` second(s).

 @param work A block that executes asynchronously on the default queue and returns a value or an
             error used to resolve the promise.
 @return A new pending promise that fulfills with the same value as the promise returned from `work`
         block, or rejects with the same error after all retry attempts have been exhausted.
 */
+ (TFBLPromise *)retry:(TFBLPromiseRetryWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise that fulfills with the same value as the promise returned from `work`
 block, which executes asynchronously on the given `queue`, or rejects with the same error after all
 retry attempts have been exhausted. Defaults to `TFBLPromiseRetryDefaultAttemptsCount` attempt(s) on
 rejection where the `work` block is retried on the given `queue` after a delay of
 `TFBLPromiseRetryDefaultDelayInterval` second(s).

 @param queue A queue to invoke the `work` block on.
 @param work A block that executes asynchronously on the given `queue` and returns a value or an
             error used to resolve the promise.
 @return A new pending promise that fulfills with the same value as the promise returned from `work`
         block, or rejects with the same error after all retry attempts have been exhausted.
 */
+ (TFBLPromise *)onQueue:(dispatch_queue_t)queue
                  retry:(TFBLPromiseRetryWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise that fulfills with the same value as the promise returned from `work`
 block, which executes asynchronously, or rejects with the same error after all retry attempts have
 been exhausted.

 @param count Max number of retry attempts. The `work` block will be executed once if the specified
              count is less than or equal to zero.
 @param work A block that executes asynchronously on the default queue and returns a value or an
             error used to resolve the promise.
 @return A new pending promise that fulfills with the same value as the promise returned from `work`
         block, or rejects with the same error after all retry attempts have been exhausted.
 */
+ (TFBLPromise *)attempts:(NSInteger)count
                   retry:(TFBLPromiseRetryWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise that fulfills with the same value as the promise returned from `work`
 block, which executes asynchronously on the given `queue`, or rejects with the same error after all
 retry attempts have been exhausted.

 @param queue A queue to invoke the `work` block on.
 @param count Max number of retry attempts. The `work` block will be executed once if the specified
              count is less than or equal to zero.
 @param work A block that executes asynchronously on the given `queue` and returns a value or an
             error used to resolve the promise.
 @return A new pending promise that fulfills with the same value as the promise returned from `work`
         block, or rejects with the same error after all retry attempts have been exhausted.
 */
+ (TFBLPromise *)onQueue:(dispatch_queue_t)queue
               attempts:(NSInteger)count
                  retry:(TFBLPromiseRetryWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise that fulfills with the same value as the promise returned from `work`
 block, which executes asynchronously, or rejects with the same error after all retry attempts have
 been exhausted. On rejection, the `work` block is retried after the given delay `interval` and will
 continue to retry until the number of specified attempts have been exhausted or will bail early if
 the given condition is not met.

 @param count Max number of retry attempts. The `work` block will be executed once if the specified
              count is less than or equal to zero.
 @param interval Time to wait before the next retry attempt.
 @param predicate Condition to check before the next retry attempt. The predicate block provides the
                  the number of remaining retry attempts and the error that the promise was rejected
                  with.
 @param work A block that executes asynchronously on the default queue and returns a value or an
             error used to resolve the promise.
 @return A new pending promise that fulfills with the same value as the promise returned from `work`
         block, or rejects with the same error after all retry attempts have been exhausted or if
         the given condition is not met.
 */
+ (TFBLPromise *)attempts:(NSInteger)count
                   delay:(NSTimeInterval)interval
               condition:(nullable TFBLPromiseRetryPredicateBlock)predicate
                   retry:(TFBLPromiseRetryWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise that fulfills with the same value as the promise returned from `work`
 block, which executes asynchronously on the given `queue`, or rejects with the same error after all
 retry attempts have been exhausted. On rejection, the `work` block is retried after the given
 delay `interval` and will continue to retry until the number of specified attempts have been
 exhausted or will bail early if the given condition is not met.

 @param queue A queue to invoke the `work` block on.
 @param count Max number of retry attempts. The `work` block will be executed once if the specified
              count is less than or equal to zero.
 @param interval Time to wait before the next retry attempt.
 @param predicate Condition to check before the next retry attempt. The predicate block provides the
                  the number of remaining retry attempts and the error that the promise was rejected
                  with.
 @param work A block that executes asynchronously on the given `queue` and returns a value or an
             error used to resolve the promise.
 @return A new pending promise that fulfills with the same value as the promise returned from `work`
         block, or rejects with the same error after all retry attempts have been exhausted or if
         the given condition is not met.
 */
+ (TFBLPromise *)onQueue:(dispatch_queue_t)queue
               attempts:(NSInteger)count
                  delay:(NSTimeInterval)interval
              condition:(nullable TFBLPromiseRetryPredicateBlock)predicate
                  retry:(TFBLPromiseRetryWorkBlock)work NS_REFINED_FOR_SWIFT;

@end

/**
 Convenience dot-syntax wrappers for `TFBLPromise+Retry` operators.
 Usage: TFBLPromise.retry(^id { ... })
 */
@interface TFBLPromise<Value>(DotSyntax_RetryAdditions)

+ (TFBLPromise * (^)(TFBLPromiseRetryWorkBlock))retry FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise * (^)(dispatch_queue_t, TFBLPromiseRetryWorkBlock))retryOn FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise * (^)(NSInteger, NSTimeInterval, TFBLPromiseRetryPredicateBlock __nullable,
                    TFBLPromiseRetryWorkBlock))retryAgain FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise * (^)(dispatch_queue_t, NSInteger, NSTimeInterval,
                    TFBLPromiseRetryPredicateBlock __nullable,
                    TFBLPromiseRetryWorkBlock))retryAgainOn FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
