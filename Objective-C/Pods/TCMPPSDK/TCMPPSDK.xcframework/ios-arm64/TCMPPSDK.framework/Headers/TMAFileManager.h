//
//  TMAFileManager.h
//  TCMPPSDK
//
//  Created by 石磊 on 2023/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMATmpPathType) {
    TMATmpPathTypeImage,
    TMATmpPathTypeVideo,
    TMATmpPathTypeGif,
    TMATmpPathTypeFile,
};

@class MABaseApplication;

@interface TMAFileManager : NSObject

@property (nonatomic, weak) MABaseApplication *application;

/**
   create a temporary file in the temporary directory of the mini program
   @param fileName file name, if nil, randomly generates a file name
   @param type file type
   @param needTimestamp whether to add a timestamp to the file name
   @return absolute file path
 */
- (nullable NSString *)createMediaTmpPathWithFileName:(NSString * _Nullable)fileName
                                        type:(TMATmpPathType)type
                               needTimestamp:(BOOL)needTimestamp;


/**
   two pair function
   translate any url to absolute url except http style
   translate any url to wxfile url except http style

   if input is http url, return self anyway

   @param filePath input path
   @return wxfile string
 */
- (nullable NSString *)translateAnyPathToWxfilePath:(NSString *)filePath;

/**
   two pair function
   translate wxfile url  to absolute url

   @param wxfilePath wxfile url
   @return absolute path string
 */
- (nullable NSString *)translateWxfilePathToAbsolutePath:(NSString *)wxfilePath;

@end

NS_ASSUME_NONNULL_END
