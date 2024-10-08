//
//  PaymentManager.h
//  TCMPPDemo
//
//  Created by gavinjwxu on 2024/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^tcmppPayRequestHandler)(NSError *_Nullable err,NSDictionary *_Nullable result);

@interface PaymentManager : NSObject

+ (void)checkPreOrder:(NSString *)prePayId completion:(tcmppPayRequestHandler)handler;

+ (void)payOrder:(NSString *)tradeNo prePayId:(NSString *)prePayId totalFee:(NSInteger)totalFee completion:(tcmppPayRequestHandler)handler;

@end

NS_ASSUME_NONNULL_END
