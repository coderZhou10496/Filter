//
//  ZJShaderImageFilter.m
//  Filter
//
//  Created by zhoujian on 2018/11/17.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJShaderImageFilter.h"


struct AdjustSaturationUniforms
{
    float saturationFactor;
};
@interface ZJShaderImageFilter()
@property (nonatomic, assign) float saturValue;
@property (nonatomic, assign) float blurValue;
@property (nonatomic, strong) id<MTLTexture> blurTexture;

@property (nonatomic, assign) NSInteger filterType;

@end


@implementation ZJShaderImageFilter


static ZJShaderImageFilter *saturFilter;
static ZJShaderImageFilter *blurFilter;

+ (void)shaderImageViewWithView:(ZJShaderImageView *)imageView saturationValue:(float)saturationValue  blurRadiusValue:(float)blurRadiusValue {
    
    id<MTLTexture> saturationOutputTexture = [self saturationOutputTextureWithSaturationValue:saturationValue View:imageView];
    id<MTLTexture> blurRadiusOutputTexture = [self blurRadiusOutputTextureWithBlurRadiusValue:blurRadiusValue View:imageView inputTexture:saturationOutputTexture];
    imageView.texture = blurRadiusOutputTexture;
    
}
+ (id<MTLTexture>)saturationOutputTextureWithSaturationValue:(float)saturationValue View:(ZJShaderImageView *)imageView {
    if(saturFilter == nil) {
        saturFilter = [[ZJShaderImageFilter alloc] initWithFunctionName:@"adjust_saturation"];
        saturFilter.filterType = 1;
        saturFilter.isDirty = YES;
    }
    
    saturFilter.saturValue = saturationValue;
    saturFilter.inputTexture = imageView.lookUpTableProvider.texture;
    saturFilter.outputTexture = imageView.lookUpTableProvider.writeTexture;
    
    return saturFilter.outputTexture;
}
+ (id<MTLTexture>)blurRadiusOutputTextureWithBlurRadiusValue:(float)blurRadiusValue View:(ZJShaderImageView *)imageView inputTexture:(id<MTLTexture>)input {
    if(blurFilter == nil) {
        blurFilter = [[ZJShaderImageFilter alloc] initWithFunctionName:@"gaussian_blur_2d"];
        blurFilter.filterType = 2;
        blurFilter.isDirty = YES;
    }
    blurFilter.blurTexture = nil;
    blurFilter.blurValue = blurRadiusValue;
    blurFilter.inputTexture = input;
    blurFilter.outputTexture = imageView.lookUpTableProvider.writeTexture;
    return blurFilter.outputTexture;
}
- (void)configDataWithComputeEncoder:(id<MTLComputeCommandEncoder>)computeEncoder {
    if(self.filterType == 1) {
        struct AdjustSaturationUniforms uniforms;
        uniforms.saturationFactor = self.isDirty ? self.saturValue : 1.0;
        id<MTLBuffer> buffer = [self.metalContext.device newBufferWithLength:sizeof(uniforms)
                                                                     options:MTLResourceOptionCPUCacheModeDefault];
        memcpy([buffer contents], &uniforms, sizeof(uniforms));
        
        [computeEncoder setBuffer:buffer offset:0 atIndex:0];
        
    }
    else {
        if(self.blurTexture == nil) {
            [self configBlurTexture];
        }
        [computeEncoder setTexture:self.blurTexture
                           atIndex:2];
        
    }
}
- (void)configBlurTexture {
    
    const float realValue = _blurValue * 8;
    const float radius = realValue;
    const float sigma = realValue/2;
    const int size = (round(radius) * 2) + 1;
    
    float delta = 0;
    float expScale = 0;;
    if (radius > 0.0)
    {
        delta = (radius * 2) / (size - 1);;
        expScale = -1 / (2 * sigma * sigma);
    }
    
    float *weights = malloc(sizeof(float) * size * size);
    
    float weightSum = 0;
    float y = -radius;
    for (int j = 0; j < size; ++j, y += delta)
    {
        float x = -radius;
        
        for (int i = 0; i < size; ++i, x += delta)
        {
            float weight = expf((x * x + y * y) * expScale);
            weights[j * size + i] = weight;
            weightSum += weight;
        }
    }
    
    const float weightScale = 1 / weightSum;
    for (int j = 0; j < size; ++j)
    {
        for (int i = 0; i < size; ++i)
        {
            weights[j * size + i] *= weightScale;
        }
    }
    
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR32Float
                                                                                                 width:size
                                                                                                height:size
                                                                                             mipmapped:NO];
    
    _blurTexture = [[ZJMetalContext defaultContext].device newTextureWithDescriptor:textureDescriptor];
    
    MTLRegion region = MTLRegionMake2D(0, 0, size, size);
    [_blurTexture replaceRegion:region mipmapLevel:0 withBytes:weights bytesPerRow:sizeof(float) * size];
    
    free(weights);
}

@end
