//
//  TMALocationModel.h
//  Kiwi
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CLLocation;
@interface TMALocationModel : NSObject

@property (nonatomic, strong) CLLocation *location;
// 纬度（WGS84地球坐标）
// Latitude (WGS84 Earth coordinates)
@property (nonatomic, assign) double latitude;
// 经度（WGS84地球坐标）
// Longitude (WGS84 Earth coordinates)
@property (nonatomic, assign) double longitude;
// 海拔高度（WGS84地球坐标）
// Altitude (WGS84 earth coordinates)
@property (nonatomic, assign) double altitude;
// 横向精确度（WGS84地球坐标）
// Lateral accuracy (WGS84 earth coordinates)
@property (nonatomic, assign) double hAccuracy;

// 纬度（GCJ02火星坐标）
// Latitude (GCJ02 Mars coordinates)
@property (nonatomic, assign) double marsLatitude;
// 经度（GCJ02火星坐标）
// Longitude (GCJ02 Mars coordinates)
@property (nonatomic, assign) double marsLongitude;

@end

NS_ASSUME_NONNULL_END
