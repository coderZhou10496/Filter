//
//  ZJMetalContext.h
//  ZJImageProcessing
//
//  Created by zhoujian on 2018/11/12.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZJMetalContext : NSObject

+ (instancetype)defaultContext;

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLLibrary> library;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

@end

NS_ASSUME_NONNULL_END
