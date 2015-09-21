//
//  SMSaveImageToPhotos.h
//  百思不得姐
//
//  Created by 宋明 on 15/9/21.
//  Copyright (c) 2015年 songm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMProgressHUD.h"
@interface SMSaveImageToPhotos : NSObject
/**
 *  保存至手机相册
 *
 *  @param UIImage image
 */

+(void )WriteToSavePhotosAlbumWithImage:(UIImage *) image;

/**
 *  保存至手机相册自定义文件夹
 *
 *  @param NSString GroupNameKey  文件夹ID
 *  @param NSString GroupName       文件夹名字
 *  @param UIImage image                需要保存的图片
 */
+(void)WriteToSaveWithGroupNameKey:(NSString *)GroupNameKey  GroupName:(NSString *)GroupName image:(UIImage *)image;
@end
