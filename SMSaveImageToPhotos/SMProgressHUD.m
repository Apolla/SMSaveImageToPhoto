//
//  SMProgressHUD.m
//  SMSaveImageToPhotosDemo
//
//  Created by 宋明 on 15/9/21.
//  Copyright © 2015年 songm. All rights reserved.
//

#import "SMProgressHUD.h"

@implementation SMProgressHUD
/*提示框View*/
static UIView *HUDView;
/*蒙版*/
static UIWindow *Window_;
/*定时器*/
static NSTimer *timer_;

/** HUD控件的动画持续时间（出现\隐藏） */
static CGFloat const SMAnimationDuration = 1;

/** HUD控件默认会停留多长时间 */
static CGFloat const SMHUDStayDuration = 1.5;

+ (void)showImage:(UIImage *)image text:(NSString *)text
{
 
    [SMProgressHUD  setupWindow];

    // 添加按钮
    UIButton *button = [[UIButton alloc] init];
    button.frame = HUDView.bounds;
    // 文字
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    // 图片
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    
    [HUDView addSubview:button];
    // 开启一个新的定时器
    timer_ = [NSTimer scheduledTimerWithTimeInterval:SMHUDStayDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];
}

+ (void)showImageName:(NSString *)imageName text:(NSString *)text
{
    [self showImage:[UIImage imageNamed:imageName] text:text];
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    [self showImageName:@"SMProgressHUD.bundle/success" text:status];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [self showImageName:@"SMProgressHUD.bundle/error" text:status];
}

+ (void)showWithStatus:(NSString *)status
{

    [SMProgressHUD  setupWindow];
    //添加图层动画
    UIView  *layerView  =  [[UIView  alloc]initWithFrame:CGRectMake(50,15, 50, 50)];
    layerView.backgroundColor  =  [UIColor  clearColor];
    [HUDView  addSubview:layerView];
    
    // 创建复制层
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
   
    repL.frame = layerView.bounds;
    
    CGFloat count = 100;
    
    CGFloat angle = M_PI * 2 / count;
    
    repL.instanceCount = count;
    
    repL.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    // 设置复制延迟动画时间 = 动画时间 / 总的个数
    repL.instanceDelay = SMAnimationDuration / count;
    
    [layerView.layer addSublayer:repL];
    
    CGFloat w = 5;
    
    // 绿色
    CALayer *greenLayer = [CALayer layer];
    
    greenLayer.cornerRadius  =  w  * 0.5;
    greenLayer.transform = CATransform3DMakeScale(0, 0, 0);
    
    greenLayer.position = CGPointMake(layerView.bounds.size.width * 0.5, w);
    greenLayer.bounds = CGRectMake(0, 0, w, w);
    
    greenLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    [repL addSublayer:greenLayer];
    
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.scale";
    
    anim.fromValue = @1;
    
    anim.toValue = @1;
    
    anim.repeatCount = MAXFLOAT;
 
    [greenLayer addAnimation:anim forKey:nil];
    
    
    UILabel  *lable  =  [[UILabel  alloc]initWithFrame:CGRectMake(0, 80, HUDView.frame.size.width, 10)];
    lable.text  =  status;
    lable.textColor  =  [UIColor  blackColor];
    lable.textAlignment  =  NSTextAlignmentCenter;
    lable.font  =  [UIFont  systemFontOfSize:14];
    [HUDView  addSubview:lable];
    // 开启一个新的定时器
    timer_ = [NSTimer scheduledTimerWithTimeInterval:SMHUDStayDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];

}

+ (void)hide
{
    // 清空定时器
    [timer_ invalidate];
    timer_ = nil;
    HUDView  =  nil;
    Window_  =  nil;
}

/*初始化*/
+ (void) setupWindow
{

    // 停止之前的定时器
    [timer_ invalidate];
    timer_ = nil;
    //创建蒙版
    Window_.hidden  =  YES;
    Window_  =  [[UIWindow alloc] init];
    Window_.backgroundColor = [UIColor  colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    Window_.windowLevel = UIWindowLevelAlert  -  1;
    Window_.frame  =  [UIScreen   mainScreen].bounds;
    Window_.hidden  =  NO;
    // 创建窗口
    HUDView = [[UIView alloc] init];
    HUDView.backgroundColor = [UIColor  colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    HUDView.layer.cornerRadius  =  8;
    HUDView.frame = CGRectMake(([UIScreen  mainScreen].bounds.size.width - 150)  *  0.5, ([UIScreen  mainScreen].bounds.size.width - 100)  *  0.5, 150, 100);
    [Window_  addSubview:HUDView];

}
@end
