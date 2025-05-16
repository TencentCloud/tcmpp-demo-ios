//
//  TMFOCSharkCmdSettings.h
//  TMFShark
//
//  Created by klaudz on 21/6/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TarsObject;

@interface TMFOCSharkCmdSettings : NSObject

+ (instancetype)settings;

#pragma mark - Command

@property (nonatomic, copy, nullable) NSString *cmd;

#pragma mark - CS

- (void)csSetCmdID:(NSInteger)cmdID objectClass:(nullable Class)objectClass;

@property (nonatomic, assign, readonly) NSInteger csCmdID;
@property (nonatomic, assign, readonly, nullable) Class csObjectClass;

#pragma mark - SC

- (void)scSetCmdID:(NSInteger)cmdID objectClass:(nullable Class)objectClass;

@property (nonatomic, assign, readonly) NSInteger scCmdID;
@property (nonatomic, assign, readonly, nullable) Class scObjectClass;

#pragma mark -

typedef NS_ENUM(NSInteger, TMFSharkDataType) {
    
    TMFSharkDataTypeTars    = 0,
    TMFSharkDataTypeRAW     = 1,
    
    TMFSharkDataTypeDefault = TMFSharkDataTypeTars,
};

@property (nonatomic, assign) TMFSharkDataType dataType;

@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest; // Defaults to 0, that follows by the `TMFSharkCenter.configuration.timeoutIntervalForRequest`.

@property (nonatomic, assign) BOOL requiresCellularAccess; // Defaults to NO.

// The network interface may be a name (e.g. "en0" or "pdp_ip0").
// Defaults to `nil`.
// If `networkInterfaceForRequest` is set as a nonnull value, `requiresCellularAccess` will be ignored.
@property (nonatomic, copy, nullable) NSString *networkInterfaceForRequest;

@property (nonatomic, assign) BOOL mergesQueuedRequests; // Defaults to YES.

@end

NS_ASSUME_NONNULL_END
