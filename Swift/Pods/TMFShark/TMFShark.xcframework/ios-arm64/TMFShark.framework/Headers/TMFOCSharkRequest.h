//
//  TMFOCSharkRequest.h
//  TMFShark
//
//  Created by klaudz on 20/6/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMFShark/TMFOCSharkCmdSettings.h>
#import <TMFShark/TMFSharkRequestHeaders.h>
#import <TMFShark/TMFSharkResponseHeaders.h>
#import <TMFShark/TMFSharkCenter.h>
#import <TMFShark/TMFSharkErrors.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TMFSharkRequestMiniCompletionHandler) (__kindof TarsObject * _Nullable scObject, NSError * _Nullable error);
typedef void (^TMFSharkRequestTarsCompletionHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, __kindof TarsObject * _Nullable scObject, NSError * _Nullable error);
typedef void (^TMFSharkRequestDataCompletionHandler) (TMFSharkResponseHeaders * _Nullable responseHeaders, NSData * _Nullable responseData, NSError * _Nullable error);

@interface TMFOCSharkRequest : NSObject

- (instancetype)initWithSharkCenter:(TMFSharkCenter *)sharkCenter;

- (instancetype)init __attribute__((deprecated("Use +masterRequest: or -initWithSharkCenter: instead")));

// Creates an autoreleased `TMFOCSharkRequest` instance by calling `-initWithSharkCenter:` with masterCenter.
+ (instancetype)masterRequest;

@property (nonatomic, readonly) TMFSharkCenter *sharkCenter;

- (void)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings csObject:(nullable TarsObject *)csObject completionHandler:(nullable TMFSharkRequestMiniCompletionHandler)completionHandler;

- (void)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings requestHeaders:(nullable TMFSharkRequestHeaders *)requestHeaders csObject:(nullable TarsObject *)csObject completionHandler:(nullable TMFSharkRequestTarsCompletionHandler)completionHandler;

- (void)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings requestHeaders:(nullable TMFSharkRequestHeaders *)requestHeaders requestData:(nullable NSData *)requestData completionHandler:(nullable TMFSharkRequestDataCompletionHandler)completionHandler;

- (void)cancel;

@end

#pragma mark - Jce

@class JceObject;

typedef void (^TMFSharkRequestMiniJceCompletionHandler) (__kindof JceObject * _Nullable scObject, NSError * _Nullable error);

@interface TMFOCSharkRequest (Jce)

- (void)requestWithCmdSettings:(TMFOCSharkCmdSettings *)cmdSettings csJceObject:(nullable JceObject *)csObject completionHandler:(nullable TMFSharkRequestMiniJceCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
