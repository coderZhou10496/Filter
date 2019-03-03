//
//  ZJShaderImageView.h
//  Filter
//
//  Created by zhoujian on 2018/11/17.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import <MetalKit/MetalKit.h>
#import "ZJTextureProvider.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJShaderImageView : MTKView

@property (nonatomic, strong) ZJTextureProvider *lookUpTableProvider;

@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image fragmentFunctionName:(NSString *)name;

- (void)configWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder;
@end

NS_ASSUME_NONNULL_END
