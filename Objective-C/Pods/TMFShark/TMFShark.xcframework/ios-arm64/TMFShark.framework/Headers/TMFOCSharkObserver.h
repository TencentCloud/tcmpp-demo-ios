//
//  TMFOCSharkObserver.h
//  TMDShark
//
//  Created by klaudz on 24/6/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMFShark/TMFOCSharkCmdSettings.h>
#import <TMFShark/TMFSharkResponseHeaders.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TMFSharkObserveTarsHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, __kindof TarsObject * _Nullable scObject);
typedef void (^TMFSharkObserveDataHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, NSData * _Nullable responseData);

@interface TMFOCSharkObserver : NSObject

@property (nonatomic, retain, nullable, readonly) TMFOCSharkCmdSettings *cmdSettings;

+ (instancetype)observerWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings scObjectHandler:(TMFSharkObserveTarsHandler)scObjectHandler;
@property (nonatomic, copy, nullable, readonly) TMFSharkObserveTarsHandler scObjectHandler;

+ (instancetype)observerWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings responseDataHandler:(TMFSharkObserveDataHandler)responseDataHandler;
@property (nonatomic, copy, nullable, readonly) TMFSharkObserveDataHandler responseDataHandler;

@end

#pragma mark - Jce

@class JceObject;

typedef void (^TMFSharkObserveJceHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, __kindof JceObject * _Nullable scObject);

@interface TMFOCSharkObserver (Jce)

+ (instancetype)observerWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings scJceObjectHandler:(TMFSharkObserveJceHandler)scObjectHandler;
@property (nonatomic, copy, nullable, readonly) TMFSharkObserveJceHandler scJceObjectHandler;

@end

NS_ASSUME_NONNULL_END
