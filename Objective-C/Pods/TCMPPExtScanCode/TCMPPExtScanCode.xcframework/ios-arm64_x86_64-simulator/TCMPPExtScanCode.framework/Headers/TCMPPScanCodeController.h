//
//  TCMPPScanCodeController.h
//  TCMPPExtScanCode
//
//  Created by stonelshi on 2024/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ScanResultHandler)(NSArray* _Nullable);
@interface TCMPPScanCodeController : UIViewController
@property(nullable, nonatomic, copy) ScanResultHandler scanResultHandler;

@property (nonatomic, assign) BOOL onlyFromCamera;
@end

NS_ASSUME_NONNULL_END
