//
//  SMProgressHUD.h
//  SMSaveImageToPhotosDemo
//
//  Created by 宋明 on 15/9/21.
//  Copyright © 2015年 songm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMProgressHUD : NSObject
+ (void)showWithStatus:(NSString  *)status;
+ (void)showErrorWithStatus:(NSString  *)status;
+ (void)showSuccessWithStatus:(NSString  *)status;
@end
