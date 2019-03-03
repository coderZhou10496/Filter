//
//  ZJBaseImageFilter.h
//  Filter
//
//  Created by zhoujian on 2018/11/16.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "ZJMetalContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJBaseImageFilter : NSObject


- (instancetype)initWithFunctionName:(NSString *)functionName;
@property (nonatomic, strong) ZJMetalContext *metalContext;
@property (nonatomic, strong) id<MTLComputePipelineState> pipelineState;
@property (nonatomic, assign) BOOL isDirty;
@property (nonatomic, strong) id<MTLTexture> inputTexture;
@property (nonatomic, strong) id<MTLTexture> outputTexture;

- (void)configDataWithComputeEncoder:(id<MTLComputeCommandEncoder>)computeEncoder;
@end


NS_ASSUME_NONNULL_END
