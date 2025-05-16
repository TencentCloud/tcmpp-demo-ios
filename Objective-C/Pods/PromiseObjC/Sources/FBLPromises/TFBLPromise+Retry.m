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

#import "TFBLPromise+Retry.h"

#import "TFBLPromisePrivate.h"

NSInteger const TFBLPromiseRetryDefaultAttemptsCount = 1;
NSTimeInterval const TFBLPromiseRetryDefaultDelayInterval = 1.0;

static void TFBLPromiseRetryAttempt(TFBLPromise *promise, dispatch_queue_t queue, NSInteger count,
                                   NSTimeInterval interval, TFBLPromiseRetryPredicateBlock predicate,
                                   TFBLPromiseRetryWorkBlock work) {
  __auto_type retrier = ^(id __nullable value) {
    if ([value isKindOfClass:[NSError class]]) {
      if (count <= 0 || (predicate && !predicate(count, value))) {
        [promise reject:value];
      } else {
        dispatch_after(dispatch_time(0, (int64_t)(interval * NSEC_PER_SEC)), queue, ^{
          TFBLPromiseRetryAttempt(promise, queue, count - 1, interval, predicate, work);
        });
      }
    } else {
      [promise fulfill:value];
    }
  };
  id value = work();
  if ([value isKindOfClass:[TFBLPromise class]]) {
    [(TFBLPromise *)value observeOnQueue:queue fulfill:retrier reject:retrier];
  } else  {
    retrier(value);
  }
}

@implementation TFBLPromise (RetryAdditions)

+ (TFBLPromise *)retry:(TFBLPromiseRetryWorkBlock)work {
  return [self onQueue:TFBLPromise.defaultDispatchQueue retry:work];
}

+ (TFBLPromise *)onQueue:(dispatch_queue_t)queue retry:(TFBLPromiseRetryWorkBlock)work {
  return [self onQueue:queue attempts:TFBLPromiseRetryDefaultAttemptsCount retry:work];
}

+ (TFBLPromise *)attempts:(NSInteger)count retry:(TFBLPromiseRetryWorkBlock)work {
  return [self onQueue:TFBLPromise.defaultDispatchQueue attempts:count retry:work];
}

+ (TFBLPromise *)onQueue:(dispatch_queue_t)queue
               attempts:(NSInteger)count
                  retry:(TFBLPromiseRetryWorkBlock)work {
  return [self onQueue:queue
              attempts:count
                 delay:TFBLPromiseRetryDefaultDelayInterval
             condition:nil
                 retry:work];
}

+ (TFBLPromise *)attempts:(NSInteger)count
                   delay:(NSTimeInterval)interval
               condition:(nullable TFBLPromiseRetryPredicateBlock)predicate
                   retry:(TFBLPromiseRetryWorkBlock)work {
  return [self onQueue:TFBLPromise.defaultDispatchQueue
              attempts:count
                 delay:interval
             condition:predicate
                 retry:work];
}

+ (TFBLPromise *)onQueue:(dispatch_queue_t)queue
               attempts:(NSInteger)count
                  delay:(NSTimeInterval)interval
              condition:(nullable TFBLPromiseRetryPredicateBlock)predicate
                  retry:(TFBLPromiseRetryWorkBlock)work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  TFBLPromise *promise = [[TFBLPromise alloc] initPending];
  TFBLPromiseRetryAttempt(promise, queue, count, interval, predicate, work);
  return promise;
}

@end

@implementation TFBLPromise (DotSyntax_RetryAdditions)

+ (TFBLPromise * (^)(TFBLPromiseRetryWorkBlock))retry {
  return ^id(TFBLPromiseRetryWorkBlock work) {
    return [self retry:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t, TFBLPromiseRetryWorkBlock))retryOn {
  return ^id(dispatch_queue_t queue, TFBLPromiseRetryWorkBlock work) {
    return [self onQueue:queue retry:work];
  };
}

+ (TFBLPromise * (^)(NSInteger, NSTimeInterval, TFBLPromiseRetryPredicateBlock,
                    TFBLPromiseRetryWorkBlock))retryAgain {
  return ^id(NSInteger count, NSTimeInterval interval, TFBLPromiseRetryPredicateBlock predicate,
             TFBLPromiseRetryWorkBlock work) {
    return [self attempts:count delay:interval condition:predicate retry:work];
  };
}

+ (TFBLPromise * (^)(dispatch_queue_t, NSInteger, NSTimeInterval, TFBLPromiseRetryPredicateBlock,
                    TFBLPromiseRetryWorkBlock))retryAgainOn {
  return ^id(dispatch_queue_t queue, NSInteger count, NSTimeInterval interval,
             TFBLPromiseRetryPredicateBlock predicate, TFBLPromiseRetryWorkBlock work) {
    return [self onQueue:queue attempts:count delay:interval condition:predicate retry:work];
  };
}

@end
