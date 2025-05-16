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

@interface TFBLPromise<Value>(ThenAdditions)

typedef id __nullable (^TFBLPromiseThenWorkBlock)(Value __nullable value) NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise which eventually gets resolved with resolution returned from `work`
 block: either value, error or another promise. The `work` block is executed asynchronously only
 when the receiver is fulfilled. If receiver is rejected, the returned promise is also rejected with
 the same error.

 @param work A block to handle the value that receiver was fulfilled with.
 @return A new pending promise to be resolved with resolution returned from the `work` block.
 */
- (TFBLPromise *)then:(TFBLPromiseThenWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/*
  在 hotFulFill 场景下，then 的 block(work) 会被 promise 一直持有
  为了能释放 block, 增加 owner 机制，owner 释放的时候，block 也会被释放
  owner 传入 nil 表示 block 会在 promise 释放的时候才释放
 */
- (TFBLPromise *)addOwner:(nullable id)owner then:(TFBLPromiseThenWorkBlock)work NS_SWIFT_UNAVAILABLE("");

/**
 Creates a pending promise which eventually gets resolved with resolution returned from `work`
 block: either value, error or another promise. The `work` block is executed asynchronously when the
 receiver is fulfilled. If receiver is rejected, the returned promise is also rejected with the same
 error.

 @param queue A queue to invoke the `work` block on.
 @param work A block to handle the value that receiver was fulfilled with.
 @return A new pending promise to be resolved with resolution returned from the `work` block.
 */
- (TFBLPromise *)onQueue:(dispatch_queue_t)queue
                   then:(TFBLPromiseThenWorkBlock)work NS_REFINED_FOR_SWIFT;

@end

/**
 Convenience dot-syntax wrappers for `TFBLPromise` `then` operators.
 Usage: promise.then(^id(id value) { ... })
 */
@interface TFBLPromise<Value>(DotSyntax_ThenAdditions)

- (TFBLPromise* (^)(TFBLPromiseThenWorkBlock))then FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
- (TFBLPromise* (^)(dispatch_queue_t, TFBLPromiseThenWorkBlock))thenOn FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
