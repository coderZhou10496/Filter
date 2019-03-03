//
//  ZJShaderLookupImageView.m
//  Filter
//
//  Created by zhoujian on 2018/12/25.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJShaderLookupImageView.h"

@implementation ZJShaderLookupImageView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    if(self = [super initWithFrame:frame image:image fragmentFunctionName:@"lookUpTableShader"]) {
        self.lookupTableTexture = [ZJTextureProvider textureProviderWithImage:[UIImage imageNamed:@"original.png"] metalContext:[ZJMetalContext defaultContext]].texture;
    }
    return self;
    
}
- (void)configWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
    
    if(self.lookupTableTexture) {
        [renderEncoder setFragmentTexture:self.lookupTableTexture
                                  atIndex:1];
    }
    
}
@end
