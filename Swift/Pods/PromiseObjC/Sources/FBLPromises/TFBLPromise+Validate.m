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

#import "TFBLPromise+Validate.h"

#import "TFBLPromisePrivate.h"

@implementation TFBLPromise (ValidateAdditions)

- (TFBLPromise*)validate:(TFBLPromiseValidateWorkBlock)predicate {
  return [self onQueue:TFBLPromise.defaultDispatchQueue validate:predicate];
}

- (TFBLPromise*)onQueue:(dispatch_queue_t)queue validate:(TFBLPromiseValidateWorkBlock)predicate {
  NSParameterAssert(queue);
  NSParameterAssert(predicate);

  TFBLPromiseChainedFulfillBlock chainedFulfill = ^id(id value) {
    return predicate(value) ? value :
                              [[NSError alloc] initWithDomain:TFBLPromiseErrorDomain
                                                         code:TFBLPromiseErrorCodeValidationFailure
                                                     userInfo:nil];
  };
  return [self chainOnQueue:queue chainedFulfill:chainedFulfill chainedReject:nil];
}

@end

@implementation TFBLPromise (DotSyntax_ValidateAdditions)

- (TFBLPromise* (^)(TFBLPromiseValidateWorkBlock))validate {
  return ^(TFBLPromiseValidateWorkBlock predicate) {
    return [self validate:predicate];
  };
}

- (TFBLPromise* (^)(dispatch_queue_t, TFBLPromiseValidateWorkBlock))validateOn {
  return ^(dispatch_queue_t queue, TFBLPromiseValidateWorkBlock predicate) {
    return [self onQueue:queue validate:predicate];
  };
}

@end
