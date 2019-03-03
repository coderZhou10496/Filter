//
//  ShaderFilterViewController.m
//  Filter
//
//  Created by zhoujian on 2018/11/16.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ShaderFilterViewController.h"
#import "ZJShaderImageView.h"
#import "ZJShaderImageFilter.h"
#define kScreen_Width ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Height ([UIScreen mainScreen].bounds.size.height)

@interface ShaderFilterViewController ()
@property (nonatomic, strong) ZJShaderImageView *imageView;
@property (nonatomic, assign) float saturValue;
@property (nonatomic, assign) float blurValue;
@end

@implementation ShaderFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *originalImg = [UIImage imageNamed:@"pikaqiu"];
    
    float width = kScreen_Width - 60;
    float height = width/originalImg.size.width * originalImg.size.height;
    CGRect frame = CGRectMake((kScreen_Width - width)/2, (kScreen_Height - height)/2 - 40 , width, height);
    
    ZJShaderImageView *imageView = [[ZJShaderImageView alloc] initWithFrame:frame image:originalImg];
    [self.view addSubview:imageView];
    
    self.imageView = imageView;
    self.saturValue = 1.0;
    self.blurValue = 0.0;
}

- (IBAction)silderValueChanged:(UISlider *)sender {
    self.saturValue = sender.value;
    [ZJShaderImageFilter shaderImageViewWithView:_imageView saturationValue:self.saturValue blurRadiusValue:self.blurValue];
}

- (IBAction)blurValueChanged:(UISlider *)sender {
    self.blurValue = sender.value;
    [ZJShaderImageFilter shaderImageViewWithView:_imageView saturationValue:self.saturValue  blurRadiusValue:self.blurValue];
}

@end
