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

#import "TFBLPromisePrivate.h"

/** All states a promise can be in. */
typedef NS_ENUM(NSInteger, TFBLPromiseState) {
  TFBLPromiseStatePending = 0,
  TFBLPromiseStateFulfilled,
  TFBLPromiseStateHotFulfilled,
  TFBLPromiseStateRejected,
};

typedef void (^TFBLPromiseObserver)(TFBLPromiseState state, id __nullable resolution);

static dispatch_queue_t gTFBLPromiseDefaultDispatchQueue;

@implementation TFBLPromise {
  /** Current state of the promise. */
  TFBLPromiseState _state;
  /**
   Set of arbitrary objects to keep strongly while the promise is pending.
   Becomes nil after the promise has been resolved.
   */
  NSMutableSet *__nullable _pendingObjects;
  /**
   Value to fulfill the promise with.
   Can be nil if the promise is still pending, was resolved with nil or after it has been rejected.
   */
  id __nullable _value;
  /**
   Error to reject the promise with.
   Can be nil if the promise is still pending or after it has been fulfilled.
   */
  NSError *__nullable _error;
  /** List of observers to notify when the promise gets resolved. */
  NSMapTable<id, NSMutableArray<TFBLPromiseObserver> *> *_observers;
}

+ (void)initialize {
  if (self == [TFBLPromise class]) {
    gTFBLPromiseDefaultDispatchQueue = dispatch_get_main_queue();
  }
}

+ (dispatch_queue_t)defaultDispatchQueue {
  @synchronized(self) {
    return gTFBLPromiseDefaultDispatchQueue;
  }
}

+ (void)setDefaultDispatchQueue:(dispatch_queue_t)queue {
  NSParameterAssert(queue);

  @synchronized(self) {
    gTFBLPromiseDefaultDispatchQueue = queue;
  }
}

+ (instancetype)pendingPromise {
  return [[self alloc] initPending];
}

+ (instancetype)resolvedWith:(nullable id)resolution {
  return [[self alloc] initWithResolution:resolution];
}

- (instancetype)init {
    NSAssert(0, @"Promise can not use init function");
    if (self = [super init]) {
        // 防止 dealloc state 状态错误导致 dispatch_group_leave 多次的 Crash
        _state = TFBLPromiseStateRejected;
    }
    return nil;
}

- (void)fulfill:(nullable id)value {
  if ([value isKindOfClass:[NSError class]]) {
    [self reject:(NSError *)value];
  } else {
    @synchronized(self) {
      if (_state == TFBLPromiseStateHotFulfilled) {
        NSAssert(0, @"can't fulfill, state is hot fulfilled");
        return;
      }
      if (_state == TFBLPromiseStatePending) {
        _state = TFBLPromiseStateFulfilled;
        _value = value;
        _pendingObjects = nil;
          
        @autoreleasepool { // 及时释放_observers持有的promise
          NSEnumerator *valueEnumerator = _observers.objectEnumerator;
          NSMutableArray<TFBLPromiseObserver> *observers;
          while (observers = [valueEnumerator nextObject]) {
            for (TFBLPromiseObserver observer in observers) {
              observer(_state, _value);
            }
          }
          _observers = nil;
        }
          
        dispatch_group_leave(TFBLPromise.dispatchGroup);
      }
    }
  }
}

// hot FulFill，可以多次 fulfill
- (void)hotFulFill:(nullable id)value {
  if ([value isKindOfClass:[NSError class]]) {
    [self reject:(NSError *)value];
  } else {
    @synchronized(self) {
      if (_state == TFBLPromiseStateFulfilled) {
        NSAssert(0, @"can't hot fulfill, state is fulfilled");
        return;
      }

      if (_state == TFBLPromiseStateRejected) {
        return;
      }

      _state = TFBLPromiseStateHotFulfilled;
      _value = value;
      _pendingObjects = nil;
        
      NSEnumerator *valueEnumerator = _observers.objectEnumerator;
      NSMutableArray<TFBLPromiseObserver> *observers;
      while (observers = [valueEnumerator nextObject]) {
        for (TFBLPromiseObserver observer in observers) {
            observer(_state, _value);
        }
      }
        
    }
  }
}

- (void)reject:(NSError *)error {
  NSAssert([error isKindOfClass:[NSError class]], @"Invalid error type.");

  if (![error isKindOfClass:[NSError class]]) {
    // Give up on invalid error type in Release mode.
    @throw error;  // NOLINT
  }
  @synchronized(self) {
    if (_state == TFBLPromiseStatePending) {
      _state = TFBLPromiseStateRejected;
      _error = error;
      _pendingObjects = nil;
      
      @autoreleasepool { // 及时释放_observers持有的promise
        NSEnumerator *valueEnumerator = _observers.objectEnumerator;
        NSMutableArray<TFBLPromiseObserver> *observers;
        while (observers = [valueEnumerator nextObject]) {
          for (TFBLPromiseObserver observer in observers) {
            observer(_state, _error);
          }
        }
        _observers = nil;
      }
      
      dispatch_group_leave(TFBLPromise.dispatchGroup);
    }
  }
}

- (void)removeAllObserver {
    [_observers removeAllObjects];
}

- (void)removeObserver:(id)observer owner:(_Nullable id)owner {
    if (!owner) {
        owner = self;
    }
    
    NSArray *array = [_observers objectForKey:owner];
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:array];
    [resultArray removeObject:observer];
    [_observers setObject:resultArray forKey:owner];
}

- (void)removeObserver:(id)observer {
    [self removeObserver:observer owner:self];
}

#pragma mark - NSObject

- (NSString *)description {
  if (self.isFulfilled) {
    return [NSString stringWithFormat:@"<%@ %p> Fulfilled: %@", NSStringFromClass([self class]),
                                      self, self.value];
  }
  if (self.isRejected) {
    return [NSString stringWithFormat:@"<%@ %p> Rejected: %@", NSStringFromClass([self class]),
                                      self, self.error];
  }
  if (self.isHotFulfilled) {
    return [NSString stringWithFormat:@"<%@ %p> Hot Fulfilled: %@", NSStringFromClass([self class]),
                                      self, self.value];
  }

  return [NSString stringWithFormat:@"<%@ %p> Pending", NSStringFromClass([self class]), self];
}

#pragma mark - Private

- (instancetype)initPending {
  self = [super init];
  if (self) {
    dispatch_group_enter(TFBLPromise.dispatchGroup);
  }
  return self;
}

- (instancetype)initWithResolution:(nullable id)resolution {
  self = [super init];
  if (self) {
    if ([resolution isKindOfClass:[NSError class]]) {
      _state = TFBLPromiseStateRejected;
      _error = (NSError *)resolution;
    } else {
      _state = TFBLPromiseStateFulfilled;
      _value = resolution;
    }
  }
  return self;
}

- (void)dealloc {
  if (_state == TFBLPromiseStatePending || _state == TFBLPromiseStateHotFulfilled) {
    dispatch_group_leave(TFBLPromise.dispatchGroup);
  }
}

- (BOOL)isPending {
  @synchronized(self) {
    return _state == TFBLPromiseStatePending;
  }
}

- (BOOL)isFulfilled {
  @synchronized(self) {
    return _state == TFBLPromiseStateFulfilled;
  }
}

- (BOOL)isHotFulfilled {
  @synchronized(self) {
    return _state == TFBLPromiseStateHotFulfilled;
  }
}

- (BOOL)isRejected {
  @synchronized(self) {
    return _state == TFBLPromiseStateRejected;
  }
}

- (nullable id)value {
  @synchronized(self) {
    return _value;
  }
}

- (NSError *__nullable)error {
  @synchronized(self) {
    return _error;
  }
}

- (NSMutableSet *__nullable)pendingObjects {
  @synchronized(self) {
    if (_state == TFBLPromiseStatePending) {
      if (!_pendingObjects) {
        _pendingObjects = [[NSMutableSet alloc] init];
      }
    }
    return _pendingObjects;
  }
}

- (void)observeOnQueue:(dispatch_queue_t)queue
               fulfill:(TFBLPromiseOnFulfillBlock)onFulfill
                reject:(TFBLPromiseOnRejectBlock)onReject {
    [self observeOnQueue:queue addOwner:nil fulfill:onFulfill reject:onReject];
}

- (void)observeOnQueue:(dispatch_queue_t)queue
              addOwner:(_Nullable id)owner
               fulfill:(TFBLPromiseOnFulfillBlock)onFulfill
                reject:(TFBLPromiseOnRejectBlock)onReject {
  NSParameterAssert(queue);
  NSParameterAssert(onFulfill);
  NSParameterAssert(onReject);

  @synchronized(self) {
    switch (_state) {
      case TFBLPromiseStatePending:
      case TFBLPromiseStateHotFulfilled: {
        if (!_observers) {
            _observers = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
        }
        if (!owner) {
            owner = self;
        }
          
        __auto_type observer = ^(TFBLPromiseState state, id __nullable resolution) {
            dispatch_group_async(TFBLPromise.dispatchGroup, queue, ^{
              switch (state) {
                case TFBLPromiseStatePending:
                  break;
                case TFBLPromiseStateFulfilled:
                  onFulfill(resolution);
                  break;
                case TFBLPromiseStateHotFulfilled:
                  onFulfill(resolution);
                  break;
                case TFBLPromiseStateRejected:
                  onReject(resolution);
                  break;
              }
            });
        };
        NSMutableArray<TFBLPromiseObserver> *ownerArray = [_observers objectForKey:owner];
        if (!ownerArray) {
            ownerArray = [NSMutableArray array];
        }
        [ownerArray addObject:observer];
        [_observers setObject:ownerArray forKey:owner];
        break;
      }
      case TFBLPromiseStateFulfilled: {
        dispatch_group_async(TFBLPromise.dispatchGroup, queue, ^{
          onFulfill(self->_value);
        });
        break;
      }

      case TFBLPromiseStateRejected: {
        dispatch_group_async(TFBLPromise.dispatchGroup, queue, ^{
          onReject(self->_error);
        });
        break;
      }
    }
  }
}

- (TFBLPromise *)chainOnQueue:(dispatch_queue_t)queue
              chainedFulfill:(TFBLPromiseChainedFulfillBlock)chainedFulfill
               chainedReject:(TFBLPromiseChainedRejectBlock)chainedReject {
    return [self chainOnQueue:queue addOwner:nil chainedFulfill:chainedFulfill chainedReject:chainedReject];
}

- (TFBLPromise *)chainOnQueue:(dispatch_queue_t)queue
                    addOwner:(nullable id)owner
              chainedFulfill:(TFBLPromiseChainedFulfillBlock)chainedFulfill
               chainedReject:(TFBLPromiseChainedRejectBlock)chainedReject {
  NSParameterAssert(queue);

  TFBLPromise *promise = [[TFBLPromise alloc] initPending];

  __weak __auto_type weakSelf = self;
  __block BOOL isHotFullfilled = NO;
  __auto_type fulfill = ^(id __nullable value) {
    __strong __auto_type self = weakSelf;
    // 在 self 已经被释放的情况，可能已经捕捉不到 isHotFullfilled 状态，这里利用 block
    // 把状态捕捉标记起来
    if (!self && isHotFullfilled) {
      [promise hotFulFill:value];
      return;
    }
    if (self.isHotFulfilled) {
      isHotFullfilled = YES;
      [promise hotFulFill:value];
      return;
    }
    [promise fulfill:value];
  };

  __auto_type resolver = ^(id __nullable value) {
    if ([value isKindOfClass:[TFBLPromise class]]) {
      [(TFBLPromise *)value observeOnQueue:queue
          fulfill:^(id __nullable value) {
            fulfill(value);
          }
          reject:^(NSError *error) {
            [promise reject:error];
          }];
    } else {
      fulfill(value);
    }
  };
  [self observeOnQueue:queue
              addOwner:owner ?: promise // 不指定owner的情况下，生命周期跟随新创建的这个promise
      fulfill:^(id __nullable value) {
        value = chainedFulfill ? chainedFulfill(value) : value;
        resolver(value);
      }
      reject:^(NSError *error) {
        id value = chainedReject ? chainedReject(error) : error;
        resolver(value);
      }];
  return promise;
}

@end

@implementation TFBLPromise (DotSyntaxAdditions)

+ (instancetype (^)(void))pending {
  return ^(void) {
    return [self pendingPromise];
  };
}

+ (instancetype (^)(id __nullable))resolved {
  return ^(id resolution) {
    return [self resolvedWith:resolution];
  };
}

@end
