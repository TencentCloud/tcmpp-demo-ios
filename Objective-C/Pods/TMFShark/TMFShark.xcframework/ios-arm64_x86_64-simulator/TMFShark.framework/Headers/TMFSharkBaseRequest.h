//
//  TMFSharkBaseRequest.h
//  TMFShark
//
//  Created by Kloudz Liang on 13-9-11.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMFShark/TMFSharkErrors.h>

@class TMFSharkCenter;
@protocol TMFSharkRequestDelegate;

// Protected methods are declared in the header file TMFSharkBaseRequest+Protected.h

/**
 * shark请求的基类。
 */
@interface TMFSharkBaseRequest : NSObject

- (instancetype)init __attribute__((deprecated("Use +masterRequest: or -initWithSharkCenter: instead")));
- (instancetype)initWithSharkCenter:(TMFSharkCenter *)sharkCenter;

// Creates an autoreleased `TMFSharkBaseRequest` instance by calling `-initWithSharkCenter:` with masterCenter.
+ (instancetype)masterRequest;

@property (nonatomic, readonly) TMFSharkCenter *sharkCenter;
@property (nonatomic, assign) id<TMFSharkRequestDelegate> delegate;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSInteger retCode; // Deprecated

// 发起请求相关的方法，public

/**
 * 发起shark请求。
 *
 * 本质上时调用类方法 +startAllRequests。
 *
 * @warning 此方法只会直接发起shark请求，不作任务数据处理，调用前需要先调用 -prepareSharkData 以准备shark的相关数据。
 */
- (void)startRequest;

/**
 * 清空delegate并取消request。
 *
 * 会在shark任务队列中停止并删除sharkData对应的任务。
 */
- (void)clearDelegateAndCancel;

@end



@protocol TMFSharkRequestDelegate <NSObject>

@required
// 请求成功，result为Model，按照具体业务返回数据实例，如MQQWeiyunFile、MQQWeiyunUserInfo等
- (void)sharkRequestDidFinish:(TMFSharkBaseRequest *)request withInfo:(NSDictionary *)info;
// 请求失败
- (void)sharkRequestDidFail:(TMFSharkBaseRequest *)request;

@end
