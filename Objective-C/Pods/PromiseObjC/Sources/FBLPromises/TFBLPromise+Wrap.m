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

#import "TFBLPromise+Wrap.h"

#import "TFBLPromise+Async.h"

@implementation TFBLPromise (WrapAdditions)

+ (instancetype)wrapCompletion:(void (^)(TFBLPromiseCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapCompletion:work];
}

+ (instancetype)onQueue:(dispatch_queue_t)queue
         wrapCompletion:(void (^)(TFBLPromiseCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock __unused _) {
                   work(^{
                     fulfill(nil);
                   });
                 }];
}

+ (instancetype)wrapObjectCompletion:(void (^)(TFBLPromiseObjectCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapObjectCompletion:work];
}

+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapObjectCompletion:(void (^)(TFBLPromiseObjectCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock __unused _) {
                   work(^(id __nullable value) {
                     fulfill(value);
                   });
                 }];
}

+ (instancetype)wrapErrorCompletion:(void (^)(TFBLPromiseErrorCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapErrorCompletion:work];
}

+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapErrorCompletion:(void (^)(TFBLPromiseErrorCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(NSError *__nullable error) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(nil);
                     }
                   });
                 }];
}

+ (instancetype)wrapObjectOrErrorCompletion:(void (^)(TFBLPromiseObjectOrErrorCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapObjectOrErrorCompletion:work];
}

+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapObjectOrErrorCompletion:(void (^)(TFBLPromiseObjectOrErrorCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(id __nullable value, NSError *__nullable error) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(value);
                     }
                   });
                 }];
}

+ (instancetype)wrapErrorOrObjectCompletion:(void (^)(TFBLPromiseErrorOrObjectCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapErrorOrObjectCompletion:work];
}

+ (instancetype)onQueue:(dispatch_queue_t)queue
    wrapErrorOrObjectCompletion:(void (^)(TFBLPromiseErrorOrObjectCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(NSError *__nullable error, id __nullable value) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(value);
                     }
                   });
                 }];
}

+ (TFBLPromise<NSArray *> *)wrap2ObjectsOrErrorCompletion:
    (void (^)(TFBLPromise2ObjectsOrErrorCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrap2ObjectsOrErrorCompletion:work];
}

+ (TFBLPromise<NSArray *> *)onQueue:(dispatch_queue_t)queue
     wrap2ObjectsOrErrorCompletion:(void (^)(TFBLPromise2ObjectsOrErrorCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(id __nullable value1, id __nullable value2, NSError *__nullable error) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(@[ value1, value2 ]);
                     }
                   });
                 }];
}

+ (TFBLPromise<NSNumber *> *)wrapBoolCompletion:(void (^)(TFBLPromiseBoolCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapBoolCompletion:work];
}

+ (TFBLPromise<NSNumber *> *)onQueue:(dispatch_queue_t)queue
                 wrapBoolCompletion:(void (^)(TFBLPromiseBoolCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock __unused _) {
                   work(^(BOOL value) {
                     fulfill(@(value));
                   });
                 }];
}

+ (TFBLPromise<NSNumber *> *)wrapBoolOrErrorCompletion:
    (void (^)(TFBLPromiseBoolOrErrorCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapBoolOrErrorCompletion:work];
}

+ (TFBLPromise<NSNumber *> *)onQueue:(dispatch_queue_t)queue
          wrapBoolOrErrorCompletion:(void (^)(TFBLPromiseBoolOrErrorCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(BOOL value, NSError *__nullable error) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(@(value));
                     }
                   });
                 }];
}

+ (TFBLPromise<NSNumber *> *)wrapIntegerCompletion:(void (^)(TFBLPromiseIntegerCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapIntegerCompletion:work];
}

+ (TFBLPromise<NSNumber *> *)onQueue:(dispatch_queue_t)queue
              wrapIntegerCompletion:(void (^)(TFBLPromiseIntegerCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock __unused _) {
                   work(^(NSInteger value) {
                     fulfill(@(value));
                   });
                 }];
}

+ (TFBLPromise<NSNumber *> *)wrapIntegerOrErrorCompletion:
    (void (^)(TFBLPromiseIntegerOrErrorCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapIntegerOrErrorCompletion:work];
}

+ (TFBLPromise<NSNumber *> *)onQueue:(dispatch_queue_t)queue
       wrapIntegerOrErrorCompletion:(void (^)(TFBLPromiseIntegerOrErrorCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(NSInteger value, NSError *__nullable error) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(@(value));
                     }
                   });
                 }];
}

+ (TFBLPromise<NSNumber *> *)wrapDoubleCompletion:(void (^)(TFBLPromiseDoubleCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapDoubleCompletion:work];
}

+ (TFBLPromise<NSNumber *> *)onQueue:(dispatch_queue_t)queue
               wrapDoubleCompletion:(void (^)(TFBLPromiseDoubleCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:(dispatch_queue_t)queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock __unused _) {
                   work(^(double value) {
                     fulfill(@(value));
                   });
                 }];
}

+ (TFBLPromise<NSNumber *> *)wrapDoubleOrErrorCompletion:
    (void (^)(TFBLPromiseDoubleOrErrorCompletion))work {
  return [self onQueue:self.defaultDispatchQueue wrapDoubleOrErrorCompletion:work];
}

+ (TFBLPromise<NSNumber *> *)onQueue:(dispatch_queue_t)queue
        wrapDoubleOrErrorCompletion:(void (^)(TFBLPromiseDoubleOrErrorCompletion))work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self onQueue:queue
                 async:^(TFBLPromiseFulfillBlock fulfill, TFBLPromiseRejectBlock reject) {
                   work(^(double value, NSError *__nullable error) {
                     if (error) {
                       reject(error);
                     } else {
                       fulfill(@(value));
                     }
                   });
                 }];
}

@end

@implementation TFBLPromise (DotSyntax_WrapAdditions)

+ (TFBLPromise * (^)(void (^)(TFBLPromiseCompletion)))wrapCompletion {
  return ^(void (^work)(TFBLPromiseCompletion)) {
    return [self wrapCompletion:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t, void (^)(TFBLPromiseCompletion)))wrapCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseCompletion)) {
    return [self onQueue:queue wrapCompletion:work];
  };
}

+ (TFBLPromise * (^)(void (^)(TFBLPromiseObjectCompletion)))wrapObjectCompletion {
  return ^(void (^work)(TFBLPromiseObjectCompletion)) {
    return [self wrapObjectCompletion:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t, void (^)(TFBLPromiseObjectCompletion)))wrapObjectCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseObjectCompletion)) {
    return [self onQueue:queue wrapObjectCompletion:work];
  };
}

+ (TFBLPromise * (^)(void (^)(TFBLPromiseErrorCompletion)))wrapErrorCompletion {
  return ^(void (^work)(TFBLPromiseErrorCompletion)) {
    return [self wrapErrorCompletion:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t, void (^)(TFBLPromiseErrorCompletion)))wrapErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseErrorCompletion)) {
    return [self onQueue:queue wrapErrorCompletion:work];
  };
}

+ (TFBLPromise * (^)(void (^)(TFBLPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletion {
  return ^(void (^work)(TFBLPromiseObjectOrErrorCompletion)) {
    return [self wrapObjectOrErrorCompletion:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t,
                    void (^)(TFBLPromiseObjectOrErrorCompletion)))wrapObjectOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseObjectOrErrorCompletion)) {
    return [self onQueue:queue wrapObjectOrErrorCompletion:work];
  };
}

+ (TFBLPromise * (^)(void (^)(TFBLPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletion {
  return ^(void (^work)(TFBLPromiseErrorOrObjectCompletion)) {
    return [self wrapErrorOrObjectCompletion:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t,
                    void (^)(TFBLPromiseErrorOrObjectCompletion)))wrapErrorOrObjectCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseErrorOrObjectCompletion)) {
    return [self onQueue:queue wrapErrorOrObjectCompletion:work];
  };
}

+ (TFBLPromise<NSArray *> * (^)(void (^)(TFBLPromise2ObjectsOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletion {
  return ^(void (^work)(TFBLPromise2ObjectsOrErrorCompletion)) {
    return [self wrap2ObjectsOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSArray *> * (^)(dispatch_queue_t, void (^)(TFBLPromise2ObjectsOrErrorCompletion)))
    wrap2ObjectsOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromise2ObjectsOrErrorCompletion)) {
    return [self onQueue:queue wrap2ObjectsOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(void (^)(TFBLPromiseBoolCompletion)))wrapBoolCompletion {
  return ^(void (^work)(TFBLPromiseBoolCompletion)) {
    return [self wrapBoolCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(TFBLPromiseBoolCompletion)))wrapBoolCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseBoolCompletion)) {
    return [self onQueue:queue wrapBoolCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(void (^)(TFBLPromiseBoolOrErrorCompletion)))
    wrapBoolOrErrorCompletion {
  return ^(void (^work)(TFBLPromiseBoolOrErrorCompletion)) {
    return [self wrapBoolOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(TFBLPromiseBoolOrErrorCompletion)))
    wrapBoolOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseBoolOrErrorCompletion)) {
    return [self onQueue:queue wrapBoolOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(void (^)(TFBLPromiseIntegerCompletion)))wrapIntegerCompletion {
  return ^(void (^work)(TFBLPromiseIntegerCompletion)) {
    return [self wrapIntegerCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(TFBLPromiseIntegerCompletion)))wrapIntegerCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseIntegerCompletion)) {
    return [self onQueue:queue wrapIntegerCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(void (^)(TFBLPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletion {
  return ^(void (^work)(TFBLPromiseIntegerOrErrorCompletion)) {
    return [self wrapIntegerOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(TFBLPromiseIntegerOrErrorCompletion)))
    wrapIntegerOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseIntegerOrErrorCompletion)) {
    return [self onQueue:queue wrapIntegerOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(void (^)(TFBLPromiseDoubleCompletion)))wrapDoubleCompletion {
  return ^(void (^work)(TFBLPromiseDoubleCompletion)) {
    return [self wrapDoubleCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(dispatch_queue_t,
                                void (^)(TFBLPromiseDoubleCompletion)))wrapDoubleCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseDoubleCompletion)) {
    return [self onQueue:queue wrapDoubleCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(void (^)(TFBLPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletion {
  return ^(void (^work)(TFBLPromiseDoubleOrErrorCompletion)) {
    return [self wrapDoubleOrErrorCompletion:work];
  };
}

+ (TFBLPromise<NSNumber *> * (^)(dispatch_queue_t, void (^)(TFBLPromiseDoubleOrErrorCompletion)))
    wrapDoubleOrErrorCompletionOn {
  return ^(dispatch_queue_t queue, void (^work)(TFBLPromiseDoubleOrErrorCompletion)) {
    return [self onQueue:queue wrapDoubleOrErrorCompletion:work];
  };
}

@end
