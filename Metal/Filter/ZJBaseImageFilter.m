//
//  ZJBaseImageFilter.m
//  Filter
//
//  Created by zhoujian on 2018/11/16.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJBaseImageFilter.h"
#import "ZJTextureProvider.h"
@interface ZJBaseImageFilter ()
@property (nonatomic, strong) id<MTLFunction> kernelFunction;

@property (nonatomic, assign) MTLSize groupSize;
@property (nonatomic, assign) MTLSize groupCount;
@end



@implementation ZJBaseImageFilter
- (instancetype)initWithFunctionName:(NSString *)functionName {
    
    if (self = [super init]) {
        
        NSError *error = nil;
        _metalContext = [ZJMetalContext defaultContext];
        _kernelFunction = [_metalContext.library newFunctionWithName:functionName];
        _pipelineState = [_metalContext.device newComputePipelineStateWithFunction:_kernelFunction error:&error];
        _groupSize = MTLSizeMake(16, 16, 1);
    }
    
    return self;
}
- (void)setInputTexture:(id<MTLTexture>)inputTexture {
    
    _inputTexture = inputTexture;
    
    if(_groupCount.width == 0 && _groupCount.width == 0) {
        //保证每个像素都有处理到
        _groupCount.width  = (inputTexture.width  + self.groupSize.width -  1) / self.groupSize.width;
        _groupCount.height = (inputTexture.height + self.groupSize.height - 1) / self.groupSize.height;
        _groupCount.depth = 1; // 我们是2D纹理，深度设为1
    }
    
}
- (void)configDataWithComputeEncoder:(id<MTLComputeCommandEncoder>)computeEncoder {
    
}
- (void)applyTexture {
    
    id<MTLCommandBuffer> commandBuffer = [_metalContext.commandQueue commandBuffer];
    
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    // 设置计算管道，以调用shaders.metal中的内核计算函数
    [computeEncoder setComputePipelineState:_pipelineState];
    // 输入纹理
    [computeEncoder setTexture:_inputTexture
                       atIndex:0];
    // 输出纹理
    [computeEncoder setTexture:_outputTexture
                       atIndex:1];
    [self configDataWithComputeEncoder:computeEncoder];
    [computeEncoder dispatchThreadgroups:self.groupCount
                   threadsPerThreadgroup:self.groupSize];
    // 调用endEncoding释放编码器，下个encoder才能创建
    [computeEncoder endEncoding];
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
    
}

- (id<MTLTexture>)outputTexture {
    if(self.isDirty) {
        [self applyTexture];
        return _outputTexture;
    }
    return _inputTexture;
}

@end
