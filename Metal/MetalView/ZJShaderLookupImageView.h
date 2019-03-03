//
//  ZJShaderLookupImageView.h
//  Filter
//
//  Created by zhoujian on 2018/12/25.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJShaderImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZJShaderLookupImageView : ZJShaderImageView

@property (nonatomic, strong) id<MTLTexture> lookupTableTexture;
@end

NS_ASSUME_NONNULL_END
