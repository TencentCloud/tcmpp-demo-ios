//
//  TMFSharkErrors.h
//  TMFShark
//
//  Created by klaudz on 25/2/2019.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - VID

FOUNDATION_EXPORT NSString *const TMFSharkVIDErrorDomain;

NS_ERROR_ENUM(TMFSharkVIDErrorDomain) {
    
    TMFSharkVIDErrorUnknown = 0,
    TMFSharkVIDErrorKeychainAccessGroupNotSet = -1001,
    TMFSharkVIDErrorKeychainAccessGroupInvalid = -1002,
    TMFSharkVIDErrorVIDTicketInvalid = -1011,
    TMFSharkVIDErrorVIDTokenInvalid = TMFSharkVIDErrorVIDTicketInvalid,
    TMFSharkVIDErrorVIDInvalid = -1012,
    TMFSharkVIDErrorSerializeFailed = -1013,
    TMFSharkVIDErrorDeserializeFailed = -1014,
};

#pragma mark - TMFSharkNetworkRequest

FOUNDATION_EXPORT NSString *const TMFSharkNetworkRequestErrorDomain;

NS_ERROR_ENUM(TMFSharkNetworkRequestErrorDomain) {
    
    TMFSharkNetworkRequestErrorUnknown = 0,
    TMFSharkNetworkRequestErrorInvalidRequestData = -1,
};

FOUNDATION_EXPORT NSString *const TMFSharkNetworkRequestStatusCodeErrorDomain;

NS_ERROR_ENUM(TMFSharkNetworkRequestStatusCodeErrorDomain) {
    
    TMFSharkNetworkRequestStatusCodeErrorUnknown = 0,
};

#pragma mark - TMFSharkTask

FOUNDATION_EXPORT NSString *const TMFSharkTaskErrorDomain;

NS_ERROR_ENUM(TMFSharkTaskErrorDomain) {
    
    TMFSharkTaskErrorUnknown = 0,
    
    TMFSharkTaskErrorDeserializeSharkDataFailed = 1301,
    TMFSharkTaskErrorEmptySashimiData = 1302,
    TMFSharkTaskErrorResponseSashimiNotFound = 1303,
};

#pragma mark - TMFSharkData

FOUNDATION_EXPORT NSString *const TMFSharkDataAccessLayerErrorDomain;

FOUNDATION_EXPORT NSString *const TMFSharkDataBusinessLayerErrorDomain;

#pragma mark - TMFSharkRequest

FOUNDATION_EXPORT NSString *const TMFSharkRequestErrorDomain;

NS_ERROR_ENUM(TMFSharkRequestErrorDomain) {
    
    TMFSharkRequestErrorUncompleted             = -999,
    TMFSharkRequestErrorUnknown                 = -99,
    
    TMFSharkRequestErrorRequestDataInvalid      = -100,
    TMFSharkRequestErrorFailedInAccessLayer     = -101,
    TMFSharkRequestErrorSerializationFailed     = -102,
    TMFSharkRequestErrorDeserializationFailed   = -103,
    TMFSharkRequestErrorResponseDataInvalid     = -104,
    TMFSharkRequestErrorFailedInBusinessLayer   = -105,
    
    TMFSharkRequestErrorTimedOut                = -10001,
};

// Deprecated
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeDefault;                 // = TMFSharkRequestErrorUncompleted
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeSuccess;                 // = 0
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeOtherError;              // = TMFSharkRequestErrorUnknown
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeRequestDataError;        // = TMFSharkRequestErrorRequestDataInvalid
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeAccessLayerError;        // = TMFSharkRequestErrorFailedInAccessLayer
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeSerializationError;      // = TMFSharkRequestErrorSerializationFailed
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeDeserializationError;    // = TMFSharkRequestErrorDeserializationFailed
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeResponseDataError;       // = TMFSharkRequestErrorResponseDataInvalid
FOUNDATION_EXPORT NSInteger const kTMFSharkRetCodeServerResultCodeError;   // = TMFSharkRequestErrorFailedInBusinessLayer

NS_ASSUME_NONNULL_END
