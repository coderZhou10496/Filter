//
//  LookupTableFilterViewController.m
//  Filter
//
//  Created by zhoujian on 2018/11/15.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "LookupTableFilterViewController.h"
#import "ZJLookupTableImageFilter.h"
#import "ZJBottomView.h"
#define kScreen_Width ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Height ([UIScreen mainScreen].bounds.size.height)

@interface LookupTableFilterViewController ()

@property (nonatomic, strong) ZJShaderLookupImageView *imageView;
@end
@implementation LookupTableFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *originalImg = [UIImage imageNamed:@"pikaqiu"];
    
    float width = kScreen_Width - 60;
    float height = width/originalImg.size.width * originalImg.size.height;
    CGRect frame = CGRectMake((kScreen_Width - width)/2, (kScreen_Height - height)/2 - 40 , width, height);
    
    ZJShaderLookupImageView *imageView = [[ZJShaderLookupImageView alloc] initWithFrame:frame image:originalImg];
    [self.view addSubview:imageView];
    
    ZJBottomView *bottomView = [[ZJBottomView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 140, kScreen_Width, 100)];
    bottomView.imageNamedArray = [self imageNamedArray];
    bottomView.selectedImage = ^(UIImage * _Nonnull lookupImage) {
        
        // 根据选中的lookupImage执行滤镜操作
        [ZJLookupTableImageFilter filterWithImageView:imageView lookupTableImage:lookupImage];
    };
    [self.view addSubview:bottomView];

}

- (NSArray *)imageNamedArray {
    return @[@"original.png",@"lookupTable1.png",@"lookupTable2.png",@"lookupTable3.png",@"lookupTable4.png"];
}

@end
