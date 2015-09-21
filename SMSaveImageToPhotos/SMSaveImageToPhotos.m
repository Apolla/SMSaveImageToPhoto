//
//  SMSaveImageToPhotos.m
//  百思不得姐
//
//  Created by 宋明 on 15/9/21.
//  Copyright (c) 2015年 songm. All rights reserved.
//

#import "SMSaveImageToPhotos.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define SMWeakSelf  __weak  typeof(self)  weakSelf  =  self;
@implementation SMSaveImageToPhotos
static  ALAssetsLibrary  *library  ;


#pragma mark   WriteToSavePhotos
/*
 *保存至相机相册
 **/
+(void )WriteToSavePhotosAlbumWithImage:(UIImage *) image
{
    [SMProgressHUD  showWithStatus:@"正在保存至本地..."];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  });
    
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SMProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        
        [SMProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
}




#pragma mark    WriteToSaveWithGroupName
/*
 *保存至自定义文件夹
 **/
+(void)WriteToSaveWithGroupNameKey:(NSString *)GroupNameKey  GroupName:(NSString *)GroupName image:(UIImage *)image
{
    __block  NSString  *groupName  =  [[NSUserDefaults  standardUserDefaults] stringForKey:GroupNameKey];
    if (groupName  == nil) {
        groupName  =  GroupName;
        [[NSUserDefaults  standardUserDefaults] setObject:groupName forKey:GroupNameKey];
        [[NSUserDefaults  standardUserDefaults] synchronize];
    }
    
    SMWeakSelf;
    library  =  [[ALAssetsLibrary alloc] init];
    __weak  ALAssetsLibrary  *weakLibrary  =  library;
    
    // 创建文件夹
    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
        if (group) { // 新创建的文件夹
            // 添加图片到文件夹中
            [weakSelf addImageToGroup:group image:image];
        } else { // 文件夹已经存在
            [weakLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:groupName]) { // 是自己创建的文件夹
                    // 添加图片到文件夹中
                    [weakSelf addImageToGroup:group image:image];
                    
                    *stop = YES; // 停止遍历
                } else if ([name isEqualToString:@"Camera Roll"]) {
                    // 文件夹被用户强制删除了
                    groupName = [groupName stringByAppendingString:@" "];
                    // 存储新的名字
                    [[NSUserDefaults standardUserDefaults] setObject:groupName forKey:GroupNameKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    // 创建新的文件夹
                    [weakLibrary addAssetsGroupAlbumWithName:groupName resultBlock:^(ALAssetsGroup *group) {
                        // 添加图片到文件夹中
                        [weakSelf addImageToGroup:group image:image];
                    } failureBlock:nil];
                }
            } failureBlock:nil];
        }
    } failureBlock:nil];
    
    
}

/**
 * 添加一张图片到某个文件夹中
 */
+ (void)addImageToGroup:(ALAssetsGroup *)group  image:(UIImage *)image
{
    __weak ALAssetsLibrary *weakLibrary = library;
    // 需要保存的图片
    CGImageRef image1 = image.CGImage;
    
    // 添加图片到【相机胶卷】
    [weakLibrary writeImageToSavedPhotosAlbum:image1 metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        [weakLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [SMProgressHUD  showWithStatus:@"正在保存至本地..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 添加一张图片到自定义的文件夹中
                [group addAsset:asset];
                [SMProgressHUD showSuccessWithStatus:@"保存成功!"];
            });
            
        } failureBlock:nil];
    }];
}


@end
