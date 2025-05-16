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

/**
 Different types of completion handlers available to be wrapped with promise.
 */
typedef void (^TFBLPromiseCompletion)(void) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseObjectCompletion)(id __nullable) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseErrorCompletion)(NSError* __nullable) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseObjectOrErrorCompletion)(id __nullable, NSError* __nullable)
    NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseErrorOrObjectCompletion)(NSError* __nullable, id __nullable)
    NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromise2ObjectsOrErrorCompletion)(id __nullable, id __nullable,
                                                    NSError* __nullable) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseBoolCompletion)(BOOL) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseBoolOrErrorCompletion)(BOOL, NSError* __nullable) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseIntegerCompletion)(NSInteger) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseIntegerOrErrorCompletion)(NSInteger, NSError* __nullable)
    NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseDoubleCompletion)(double) NS_SWIFT_UNAVAILABLE("");
typedef void (^TFBLPromiseDoubleOrErrorCompletion)(double, NSError* __nullable)
    NS_SWIFT_UNAVAILABLE("");

/**
 Provides an easy way to convert methods that use common callback patterns into promises.
 */
@interface TFBLPromise<Value>(WrapAdditions)

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with `nil` when completion handler is invoked.
 */
+ (instancetype)wrapCompletion:(void (^)(TFBLPromiseCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with `nil` when completion handler is invoked.
 */
+ (instancetype)onQueue:(dispatch_queue_t)queue
         wrapCompletion:(void (^)(TFBLPromiseCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an object provided by completion handler.
 */
+ (instancetype)wrapObjectCompletion:(void (^)(TFBLPromiseObjectCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an object provided by completion handler.
 */
+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapObjectCompletion:(void (^)(TFBLPromiseObjectCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an error provided by completion handler.
 If error is `nil`, fulfills with `nil`, otherwise rejects with the error.
 */
+ (instancetype)wrapErrorCompletion:(void (^)(TFBLPromiseErrorCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an error provided by completion handler.
 If error is `nil`, fulfills with `nil`, otherwise rejects with the error.
 */
+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapErrorCompletion:(void (^)(TFBLPromiseErrorCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an object provided by completion handler if error is `nil`.
 Otherwise, rejects with the error.
 */
+ (instancetype)wrapObjectOrErrorCompletion:
    (void (^)(TFBLPromiseObjectOrErrorCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an object provided by completion handler if error is `nil`.
 Otherwise, rejects with the error.
 */
+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapObjectOrErrorCompletion:(void (^)(TFBLPromiseObjectOrErrorCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an error or object provided by completion handler. If error
 is not `nil`, rejects with the error.
 */
+ (instancetype)wrapErrorOrObjectCompletion:
    (void (^)(TFBLPromiseErrorOrObjectCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an error or object provided by completion handler. If error
 is not `nil`, rejects with the error.
 */
+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapErrorOrObjectCompletion:(void (^)(TFBLPromiseErrorOrObjectCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an array of objects provided by completion handler in order
 if error is `nil`. Otherwise, rejects with the error.
 */
+ (TFBLPromise<NSArray*>*)wrap2ObjectsOrErrorCompletion:
    (void (^)(TFBLPromise2ObjectsOrErrorCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an array of objects provided by completion handler in order
 if error is `nil`. Otherwise, rejects with the error.
 */
+ (TFBLPromise<NSArray*>*)onQueue:(dispatch_queue_t)queue
    wrap2ObjectsOrErrorCompletion:(void (^)(TFBLPromise2ObjectsOrErrorCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping YES/NO.
 */
+ (TFBLPromise<NSNumber*>*)wrapBoolCompletion:(void (^)(TFBLPromiseBoolCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping YES/NO.
 */
+ (TFBLPromise<NSNumber*>*)onQueue:(dispatch_queue_t)queue
               wrapBoolCompletion:(void (^)(TFBLPromiseBoolCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping YES/NO when error is `nil`.
 Otherwise rejects with the error.
 */
+ (TFBLPromise<NSNumber*>*)wrapBoolOrErrorCompletion:
    (void (^)(TFBLPromiseBoolOrErrorCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping YES/NO when error is `nil`.
 Otherwise rejects with the error.
 */
+ (TFBLPromise<NSNumber*>*)onQueue:(dispatch_queue_t)queue
        wrapBoolOrErrorCompletion:(void (^)(TFBLPromiseBoolOrErrorCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping an integer.
 */
+ (TFBLPromise<NSNumber*>*)wrapIntegerCompletion:(void (^)(TFBLPromiseIntegerCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping an integer.
 */
+ (TFBLPromise<NSNumber*>*)onQueue:(dispatch_queue_t)queue
            wrapIntegerCompletion:(void (^)(TFBLPromiseIntegerCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping an integer when error is `nil`.
 Otherwise rejects with the error.
 */
+ (TFBLPromise<NSNumber*>*)wrapIntegerOrErrorCompletion:
    (void (^)(TFBLPromiseIntegerOrErrorCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping an integer when error is `nil`.
 Otherwise rejects with the error.
 */
+ (TFBLPromise<NSNumber*>*)onQueue:(dispatch_queue_t)queue
     wrapIntegerOrErrorCompletion:(void (^)(TFBLPromiseIntegerOrErrorCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping a double.
 */
+ (TFBLPromise<NSNumber*>*)wrapDoubleCompletion:(void (^)(TFBLPromiseDoubleCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping a double.
 */
+ (TFBLPromise<NSNumber*>*)onQueue:(dispatch_queue_t)queue
             wrapDoubleCompletion:(void (^)(TFBLPromiseDoubleCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

/**
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping a double when error is `nil`.
 Otherwise rejects with the error.
 */
+ (TFBLPromise<NSNumber*>*)wrapDoubleOrErrorCompletion:
    (void (^)(TFBLPromiseDoubleOrErrorCompletion handler))work NS_SWIFT_UNAVAILABLE("");

/**
 @param queue A queue to invoke the `work` block on.
 @param work A block to perform any operations needed to resolve the promise.
 @returns A promise that resolves with an `NSNumber` wrapping a double when error is `nil`.
 Otherwise rejects with the error.
 */
+ (TFBLPromise<NSNumber*>*)onQueue:(dispatch_queue_t)queue
      wrapDoubleOrErrorCompletion:(void (^)(TFBLPromiseDoubleOrErrorCompletion handler))work
    NS_SWIFT_UNAVAILABLE("");

@end

/**
 Convenience dot-syntax wrappers for `TFBLPromise` `wrap` operators.
 Usage: TFBLPromise.wrapCompletion(^(TFBLPromiseCompletion handler) {...})
 */
@interface TFBLPromise<Value>(DotSyntax_WrapAdditions)

+ (TFBLPromise* (^)(void (^)(TFBLPromiseCompletion)))wrapCompletion FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(dispatch_queue_t, void (^)(TFBLPromiseCompletion)))wrapCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(void (^)(TFBLPromiseObjectCompletion)))wrapObjectCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(dispatch_queue_t, void (^)(TFBLPromiseObjectCompletion)))wrapObjectCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(void (^)(TFBLPromiseErrorCompletion)))wrapErrorCompletion FBL_PROMISES_DOT_SYNTAX
    NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(dispatch_queue_t, void (^)(TFBLPromiseErrorCompletion)))wrapErrorCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(void (^)(TFBLPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(dispatch_queue_t,
                   void (^)(TFBLPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(void (^)(TFBLPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise* (^)(dispatch_queue_t,
                   void (^)(TFBLPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSArray*>* (^)(void (^)(TFBLPromise2ObjectsOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletion FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSArray*>* (^)(dispatch_queue_t, void (^)(TFBLPromise2ObjectsOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletionOn FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(void (^)(TFBLPromiseBoolCompletion)))wrapBoolCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(dispatch_queue_t,
                              void (^)(TFBLPromiseBoolCompletion)))wrapBoolCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(void (^)(TFBLPromiseBoolOrErrorCompletion)))wrapBoolOrErrorCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(dispatch_queue_t,
                              void (^)(TFBLPromiseBoolOrErrorCompletion)))wrapBoolOrErrorCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(void (^)(TFBLPromiseIntegerCompletion)))wrapIntegerCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(dispatch_queue_t,
                              void (^)(TFBLPromiseIntegerCompletion)))wrapIntegerCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(void (^)(TFBLPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletion FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(dispatch_queue_t, void (^)(TFBLPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletionOn FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(void (^)(TFBLPromiseDoubleCompletion)))wrapDoubleCompletion
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(dispatch_queue_t,
                              void (^)(TFBLPromiseDoubleCompletion)))wrapDoubleCompletionOn
    FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(void (^)(TFBLPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletion FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");
+ (TFBLPromise<NSNumber*>* (^)(dispatch_queue_t, void (^)(TFBLPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletionOn FBL_PROMISES_DOT_SYNTAX NS_SWIFT_UNAVAILABLE("");

@end

NS_ASSUME_NONNULL_END
