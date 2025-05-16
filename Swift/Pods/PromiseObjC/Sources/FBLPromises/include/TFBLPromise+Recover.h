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

@interface TFBLPromise<Value>(RecoverAdditions)

typedef id __nullable (^TFBLPromiseRecoverWorkBlock)(NSError *error) NS_SWIFT_UNAVAILABLE("");

/**
 Provides a new promise to recover in case the receiver gets rejected.

 @param recovery A block to handle the error that the receiver was rejected with.
 @return A new pending promise to use instead of the rejected one that gets resolved with resolution
         returned from `recovery` block.
 */
- (TFBLPromise *)recover:(TFBLPromiseRecoverWorkBlock)recovery NS_SWIFT_UNAVAILABLE("");

/**
 Provides a new promise to recover in case the receiver gets rejected.

 @param queue A queue to dispatch on.
 @param recovery A block to handle the error that the receiver was rejected with.
 @return A new pending promise to use instead of the rejected one that gets resolved with resolution
         returned from `recovery` block.
 */
- (TFBLPromise *)onQueue:(dispatch_queue_t)queue
                recover:(TFBLPromiseRecoverWorkBlock)recovery NS_REFINED_FOR_SWIFT;

@end

/**
 Convenience dot-syntax wrappers for `TFBLPromise` `recover` operators.
 Usage: promise.recover(^id(NSError *error) {...})
 */
@interface TFBLPromise<Value>(DotSyntax_RecoverAdditions)

- (TFBLPromise * (^)(TFBLPromiseRecoverWorkBlock))recover FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");
- (TFBLPromise * (^)(dispatch_queue_t, TFBLPromiseRecoverWorkBlock))recoverOn FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
