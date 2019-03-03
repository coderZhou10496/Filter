//
//  ZJShaderImageView.m
//  Filter
//
//  Created by zhoujian on 2018/11/17.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJShaderImageView.h"
#import "ZJMetalContext.h"
#import "ZJTextureProvider.h"
#import "ZJShaderTypes.h"

@interface ZJShaderImageView()<MTKViewDelegate>
{
    id<MTLRenderPipelineState> _pipelineState;
    
    id<MTLBuffer> _buffer;
    id<MTLBuffer> _comBuffer;
    NSUInteger _numVertices;
    
    
    vector_uint2 _viewportSize;
    ZJMetalContext *_metalContext;
    
    id<MTLTexture> _finalTexture;
    
}

@end

@implementation ZJShaderImageView

struct AdjustSaturationUniforms
{
    float saturationFactor;
};

static const ZJVertex quadVertices[] =
{   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
    { {  1.0, -1.0, 0.0, 1.0 },  { 1.f, 1.f } },
    { { -1.0, -1.0, 0.0, 1.0 },  { 0.f, 1.f } },
    { { -1.0,  1.0, 0.0, 1.0 },  { 0.f, 0.f } },
    
    { {  1.0, -1.0, 0.0, 1.0 },  { 1.f, 1.f } },
    { { -1.0,  1.0, 0.0, 1.0 },  { 0.f, 0.f } },
    { {  1.0,  1.0, 0.0, 1.0 },  { 1.f, 0.f } },
};

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image fragmentFunctionName:(NSString *)name {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if(self = [super initWithFrame:frame device:device]) {
        
        _metalContext = [ZJMetalContext defaultContext];
        
        
        _viewportSize = (vector_uint2){self.drawableSize.width, self.drawableSize.height};
        
        id<MTLLibrary> defaultLibrary = _metalContext.library ;
        // 顶点shader，vertexShader是函数名
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        // 片元shader，samplingShader是函数名
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:name];
        
        
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Simple Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        //        输出颜色格式
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat;
        
        _pipelineState = [_metalContext.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                              error:nil];
        
        _buffer = [_metalContext.device newBufferWithBytes:quadVertices
                                                    length:sizeof(quadVertices)
                                                   options:MTLResourceStorageModeShared]; // 创建顶点缓存
        
        _numVertices = sizeof(quadVertices) / sizeof(ZJVertex); // 顶点个数
        
        ZJTextureProvider * textureProvider = [ZJTextureProvider textureProviderWithImage:image metalContext:_metalContext];
        _texture = textureProvider.texture;
        _lookUpTableProvider = textureProvider;
        
    };
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    
    return [self initWithFrame:frame image:image fragmentFunctionName:@"samplingShader"];
}
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size{
    _viewportSize = (vector_uint2){size.width, size.height};
}
- (void)didMoveToSuperview {
    self.delegate = self;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    
    id<MTLCommandBuffer> commandBuffer = [_metalContext.commandQueue commandBuffer];
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if(renderPassDescriptor != nil) {
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1.0f); // 设置默认颜色
        
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0 }];
        
        [renderEncoder setRenderPipelineState:_pipelineState];// 设置渲染管道，以保证顶点和片元两个shader会被调用
        
        [renderEncoder setVertexBuffer:_buffer offset:0 atIndex:0];// 设置顶点缓存
        
        [renderEncoder setFragmentTexture:_texture
                                  atIndex:0]; // 设置纹理
        [self configWithRenderEncoder:renderEncoder];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:_numVertices];
        
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
    
}
- (void)configWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
    
}
- (void)setTexture:(id<MTLTexture>)texture {
    _texture = texture;
}
@end
