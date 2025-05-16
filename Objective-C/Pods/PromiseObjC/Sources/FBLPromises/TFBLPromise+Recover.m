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

#import "TFBLPromise+Recover.h"

#import "TFBLPromisePrivate.h"

@implementation TFBLPromise (RecoverAdditions)

- (TFBLPromise *)recover:(TFBLPromiseRecoverWorkBlock)recovery {
  return [self onQueue:TFBLPromise.defaultDispatchQueue recover:recovery];
}

- (TFBLPromise *)onQueue:(dispatch_queue_t)queue recover:(TFBLPromiseRecoverWorkBlock)recovery {
  NSParameterAssert(queue);
  NSParameterAssert(recovery);

  return [self chainOnQueue:queue
             chainedFulfill:nil
              chainedReject:^id(NSError *error) {
                return recovery(error);
              }];
}

@end

@implementation TFBLPromise (DotSyntax_RecoverAdditions)

- (TFBLPromise * (^)(TFBLPromiseRecoverWorkBlock))recover {
  return ^(TFBLPromiseRecoverWorkBlock recovery) {
    return [self recover:recovery];
  };
}

- (TFBLPromise * (^)(dispatch_queue_t, TFBLPromiseRecoverWorkBlock))recoverOn {
  return ^(dispatch_queue_t queue, TFBLPromiseRecoverWorkBlock recovery) {
    return [self onQueue:queue recover:recovery];
  };
}

@end
