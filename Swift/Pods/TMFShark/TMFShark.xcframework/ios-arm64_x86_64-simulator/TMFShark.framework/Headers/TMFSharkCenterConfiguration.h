//
//  TMFSharkCenterConfiguration.h
//  TMFShark
//
//  Created by klaudz on 19/4/2018.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMFShark/TMFSharkDefines.h>
@protocol TMFSharkCenterConfigurationDelegate <NSObject>

@optional
- (NSURLSession *_Nonnull)sessionWithConfiguration:(NSURLSessionConfiguration *_Nonnull)configuration delegate:(_Nonnull id)delegate delegateQueue:(nullable NSOperationQueue *)queue;
- (NSURLSessionTask *_Nonnull)downloadTaskWithRequest:(NSURLRequest *_Nonnull)request;
- (NSURLSessionTask *_Nonnull)dataTaskWithRequest:(NSURLRequest *_Nonnull)request;
@end
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TMFSSLPinningMode) {
    TMFSSLPinningModeNone,
    TMFSSLPinningModePublicKey,
    TMFSSLPinningModeCertificate,
};

@interface TMFSharkCenterConfiguration : NSObject

#pragma mark - Basic Configurations

@property (nonatomic, assign) NSInteger productID;
@property (nonatomic, copy) NSString *buildVersion;
@property (nonatomic, copy) NSString *buildNumber;
@property (nonatomic, copy) NSString *LCString;
@property (nonatomic, copy) NSString *channelID;

@property (nonatomic, assign) TMFSharkPlatform platform; // Defaults to TMFSharkPlatformIOS.
@property (nonatomic, assign) TMFSharkSubplatform subplatform; // Defaults to TMFSharkSubplatformIPhone.

#pragma mark - Server Configurations

@property (nonatomic, copy) NSString *HTTPURL;
@property (nonatomic, copy, nullable) NSString * HTTPURL_IPv4;

#pragma mark - Security Configurations

@property (nonatomic, copy) NSString *productKey;

// Configuration properties for RSA
@property (nonatomic, copy, nullable) NSString *RSAPublicKey;

// Configuration properties for SM2
@property (nonatomic, copy, nullable) NSString *SM2PublicKey;

// Configuration properties for HTTPS SSL CER
@property (nonatomic, assign) TMFSSLPinningMode SSLPinningMode;

#pragma mark - Request

@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest; // Glabal timeout interval settings for requests. Defaults to 15 seconds.
@property (nonatomic, assign) NSInteger HTTPMaximumConnections; // The maximum number of simultaneous connections to make to a given host. The default value is 6 in macOS, or 4 in iOS.
@property (nonatomic, assign) NSUInteger HTTPRetryCountPerRequest; // The retry count of a request when a HTTP error occurs. The default value is 0.
@property (nonatomic, assign) BOOL mergesQueuedRequests;
@property (nullable, copy)    NSDictionary *connectionProxyDictionary; /* The proxy dictionary, as described by <CFNetwork/CFHTTPStream.h> */
@property (nullable, copy)    NSDictionary <NSString*,NSString*> *HTTPHeader;
@property (nullable, assign)  id<TMFSharkCenterConfigurationDelegate> delegate;

#pragma mark - GUID

@property (nonatomic, copy, nullable) NSString *appGroup;

@property (nonatomic, copy, nullable) NSString *customizedUUID;
@property (nonatomic, copy, nullable) NSString *customizedUDID;

@property (nonatomic, copy, nullable) NSString *extraneousGUID;

#pragma mark - VID

@property (nonatomic, assign) BOOL requiresVID; // Defaults to NO.

@property (nonatomic, copy, nullable) NSString *keychainAccessGroup;
@property (nonatomic, copy, nullable) NSString *customerID;

#pragma mark - Extension

@property (nonatomic, assign) BOOL enforceCheckMasterEvent; // Defaults to NO.
@property (nonatomic, copy, nullable) NSDictionary *extConfigInfo;

@property (nonatomic, assign) int symEnc; // 1-XXTEA  2-SM4

@property (nonatomic, assign) int asymEnc; // 0-RSA 1-SM2
#pragma mark - Account

@property (nonatomic, assign) long long accountID;

- (void)configWithJsonFile:(NSString *)filePath;
- (void)configWithJsonString:(NSString *)jsonString;
- (void)configWithJsonData:(NSData *)jsonData;

@end

@interface TMFSharkCenterConfiguration (MasterCenter)

+ (instancetype)masterConfiguration;

@end

@interface TMFSharkCenterConfiguration (Debug)

@property (class, nonatomic, assign) NSUInteger logLevels;

@end

NS_ASSUME_NONNULL_END
