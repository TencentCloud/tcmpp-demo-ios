//
//  TMAChooseMessageFileModel.h
//  Kiwi
//
//  Created by miniapptmf on 2019/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMAChooseMessageFileType) {
    TMAChooseMessageFileTypeVideo = 1,
    TMAChooseMessageFileTypeAudio,
    TMAChooseMessageFileTypeImage,
    TMAChooseMessageFileTypeFile,
};

@interface TMAChooseMessageFileModel : NSObject

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) PHAsset *asset; // 可以选择本地相册图片or视频 如有需要忽略path

@property (nonatomic, assign) NSInteger size; // 单位B
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) TMAChooseMessageFileType type;
@property (nonatomic, assign) CGFloat time;

@end

NS_ASSUME_NONNULL_END
