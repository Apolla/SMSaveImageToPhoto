//
//  ViewController.m
//  SMSaveImageToPhotosDemo
//
//  Created by 宋明 on 15/9/21.
//  Copyright (c) 2015年 songm. All rights reserved.
//

#import "ViewController.h"
#import "SMSaveImageToPhotos.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIButton *save1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.save.layer.cornerRadius  =  5;
    self.save1.layer.cornerRadius  =  5;
}

- (IBAction)SaveToPhotos
{
    
    [SMSaveImageToPhotos  WriteToSavePhotosAlbumWithImage:self.imageView.image];
    
}

- (IBAction)SaveToPhotoGroup
{
    
    [SMSaveImageToPhotos  WriteToSaveWithGroupNameKey:@"Test" GroupName:@"testGroup" image:self.imageView.image];
    
}

@end
