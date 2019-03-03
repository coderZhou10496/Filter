//
//  ZJMetalContext.m
//  ZJImageProcessing
//
//  Created by zhoujian on 2018/11/12.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJMetalContext.h"

@implementation ZJMetalContext

+ (instancetype)defaultContext {
    static dispatch_once_t onceToken;
    static ZJMetalContext *context = nil;
    dispatch_once(&onceToken, ^{
        
        context = [ZJMetalContext new];
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        if(!device) {
            NSLog(@"device is nil");
        }
        else {
            context.device = device;
            context.library = [device newDefaultLibrary];
            context.commandQueue = [device newCommandQueue];
        }
    });
    return context;
}

@end
