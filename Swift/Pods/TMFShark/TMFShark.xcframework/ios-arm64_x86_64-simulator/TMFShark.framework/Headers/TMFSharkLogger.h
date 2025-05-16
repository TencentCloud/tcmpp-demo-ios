//
//  TMFSharkLogger.h
//  AFNetworking
//
//  Created by stonelshi on 2019/5/24.
//

#import <Foundation/Foundation.h>
#import <TMFShark/TMFSharkDefines.h>

NS_ASSUME_NONNULL_BEGIN

extern BOOL TMFSharkLogger_registered;

@interface TMFSharkLogger : NSObject

+ (instancetype)defaultLogger;
- (void)registerLogger:(TMFShark_Logger)logger;

- (void)addLog:(TMFSharkLogLevel)logLevel fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
