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

#import "TFBLPromise+Then.h"

#import "TFBLPromisePrivate.h"

@implementation TFBLPromise (ThenAdditions)

- (TFBLPromise *)then:(TFBLPromiseThenWorkBlock)work {
    return [self addOwner:nil then:work];
}

- (TFBLPromise *)addOwner:(nullable id)owner then:(TFBLPromiseThenWorkBlock)work {
    return [self addOwner:owner onQueue:TFBLPromise.defaultDispatchQueue then:work];
}

- (TFBLPromise *)onQueue:(dispatch_queue_t)queue then:(TFBLPromiseThenWorkBlock)work {
    return [self addOwner:nil onQueue:queue then:work];
}

- (TFBLPromise *)addOwner:(nullable id)owner onQueue:(dispatch_queue_t)queue then:(TFBLPromiseThenWorkBlock)work {
  NSParameterAssert(queue);
  NSParameterAssert(work);

  return [self chainOnQueue:queue addOwner:owner chainedFulfill:work chainedReject:nil];
}

@end

@implementation TFBLPromise (DotSyntax_ThenAdditions)

- (TFBLPromise* (^)(TFBLPromiseThenWorkBlock))then {
  return ^(TFBLPromiseThenWorkBlock work) {
    return [self then:work];
  };
}

- (TFBLPromise* (^)(dispatch_queue_t, TFBLPromiseThenWorkBlock))thenOn {
  return ^(dispatch_queue_t queue, TFBLPromiseThenWorkBlock work) {
    return [self onQueue:queue then:work];
  };
}

@end
