//
//  NSError+MiniAppSDK.h
//  MiniAppSDK
//
//



NS_ASSUME_NONNULL_BEGIN

@interface NSError (MiniAppSDK)

+(instancetype)tmaErrorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict;

+(instancetype)tmaErrorWithDomain:(NSErrorDomain)domain code:(NSInteger)code number:(int)number;

+(instancetype)tmaErrorFromSharkError:(NSError *)error withTraceId:(NSString *)traceId;

+(instancetype)tmaErrorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict withTraceId:(NSString *)traceId;

+(instancetype)tmaErrorWithDomain:(NSErrorDomain)domain code:(NSInteger)code number:(int)number withTraceId:(NSString *)traceId;

@end

NS_ASSUME_NONNULL_END
