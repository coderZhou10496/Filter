//
//  ZJTextureProvider.m
//  ZJImageProcessing
//
//  Created by zhoujian on 2018/11/12.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#import "ZJTextureProvider.h"
@interface ZJTextureProvider ()
@property (nonatomic, strong, readwrite) id<MTLTexture> texture;
@property (nonatomic, strong, readwrite) id<MTLTexture> writeTexture;
@end
@implementation ZJTextureProvider

+ (instancetype)textureProviderWithImage:(UIImage *)image metalContext:(ZJMetalContext *)context {
    
    return  [[self alloc] initWithImage:image metalContext:context];
    
}

- (instancetype)initWithImage:(UIImage *)image metalContext:(ZJMetalContext *)context {
    if(self = [super init]) {
        self.texture = [self textureForImage:image context:context];
        
    }
    return self;
}

- (id<MTLTexture>)textureForImage:(UIImage *)image context:(ZJMetalContext *)context
{

    CGImageRef spriteImage = image.CGImage;
    
    // 1 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    Byte * spriteData = (Byte *) calloc(width * height * 4, sizeof(Byte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 2 在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                                                                 width:width
                                                                                                height:height
                                                                                             mipmapped:NO];
    textureDescriptor.usage = MTLTextureUsageShaderRead;
    id<MTLTexture> texture = [context.device newTextureWithDescriptor:textureDescriptor];
    
    
    MTLRegion region = {{ 0, 0, 0 }, {image.size.width, image.size.height, 1}}; // 纹理上传的范围
    [texture replaceRegion:region mipmapLevel:0 withBytes:spriteData bytesPerRow:4 * image.size.width];
    free(spriteData);
    
    textureDescriptor.usage = MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
    self.writeTexture = [context.device newTextureWithDescriptor:textureDescriptor];
    return texture;
}

@end
