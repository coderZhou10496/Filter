//
//  ZJLookupTableImageFilter.m
//  Filter
//
//  Created by zhoujian on 2018/11/16.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJLookupTableImageFilter.h"
#import "ZJTextureProvider.h"

@interface ZJLookupTableImageFilter()
@property (nonatomic, strong) id<MTLTexture> lutTexture;
@end
@implementation ZJLookupTableImageFilter

static ZJLookupTableImageFilter *lookupFilter;

+ (void)filterWithImageView:(ZJShaderLookupImageView *)imageView lookupTableImage:(UIImage *)lutImage {

    ZJTextureProvider *provider = [ZJTextureProvider textureProviderWithImage:lutImage metalContext:[ZJMetalContext defaultContext]];
    imageView.lookupTableTexture = provider.texture;
}

@end
