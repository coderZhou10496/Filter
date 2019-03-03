//
//  ZJLookupTableImageFilter.h
//  Filter
//
//  Created by zhoujian on 2018/11/16.
//  Copyright © 2018年 zhoujian. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZJBaseImageFilter.h"
#import "ZJShaderLookupImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJLookupTableImageFilter : ZJBaseImageFilter

+ (void)filterWithImageView:(ZJShaderLookupImageView *)imageView lookupTableImage:(UIImage *)lutImage;

@end

NS_ASSUME_NONNULL_END
