//
//  ZJShaderImageFilter.h
//  Filter
//
//  Created by zhoujian on 2018/11/17.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJBaseImageFilter.h"
#import "ZJShaderImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJShaderImageFilter : ZJBaseImageFilter

+ (void)shaderImageViewWithView:(ZJShaderImageView *)imageView saturationValue:(float)saturationValue  blurRadiusValue:(float)blurRadiusValue;

@end

NS_ASSUME_NONNULL_END
