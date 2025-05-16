//
//  TMAServerConfig.h
//  TMFApplet
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMAServerConfig : NSObject

@property (nonatomic, copy, readonly) NSString *customID;
@property (nonatomic, copy, readonly) NSString *bundleID;

@property (nonatomic, assign, readonly) NSInteger productId;
@property (nonatomic, copy, readonly) NSString *feedbackUrl;
@property (nonatomic, copy, readonly) NSString *qapmBaseUrl;


// 可配置使用者自己的UDID信息
// Configurable user's own UDID information
@property (nonatomic, copy) NSString *customizedUDID;

// 可配置接入地址，替换配置文件信息中的接入地址
// Configurable access address, replace the access address in the configuration file information
@property (nonatomic, copy) NSString *serverUrl;

- (instancetype)initWithSting:(NSString*)configString;
- (instancetype)initWithFile:(NSString*)filePath;

- (NSString *)getAppKey;
- (NSString *)getCustomID;
- (NSString *)getHttpUrl;
@end

NS_ASSUME_NONNULL_END
