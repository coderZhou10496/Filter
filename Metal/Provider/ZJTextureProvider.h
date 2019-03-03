//
//  ZJTextureProvider.h
//  ZJImageProcessing
//
//  Created by zhoujian on 2018/11/12.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import "ZJMetalContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZJTextureProvider : NSObject

+ (instancetype)textureProviderWithImage:(UIImage *)image metalContext:(ZJMetalContext *)context;

@property (nonatomic, strong, readonly) id<MTLTexture> texture;

@property (nonatomic, strong, readonly) id<MTLTexture> writeTexture;

@end

NS_ASSUME_NONNULL_END
