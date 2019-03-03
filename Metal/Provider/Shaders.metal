//
//  Shaders.metal
//  Triangle
//
//  Created by watchnail on 2018/4/20.
//  Copyright © 2018年 watchnail. All rights reserved.
//

#include <metal_stdlib>

#import "ZJShaderTypes.h"

using namespace metal;


struct AdjustSaturationUniforms
{
    float saturationFactor;
};

typedef struct
{
    float4 clipSpacePosition [[position]]; // position的修饰符表示这个是顶点
    
    float2 textureCoordinate; // 纹理坐标，会做插值处理
    
} RasterizerData;


//shader有三个基本函数：
//
//顶点函数（vertex），对每个顶点进行处理，生成数据并输出到绘制管线；
//像素函数（fragment），对光栅化后的每个像素点进行处理，生成数据并输出到绘制管线；
//通用计算函数（kernel），是并行计算的函数，其返回值类型必须为void；


vertex RasterizerData // 返回给片元着色器的结构体
vertexShader(uint vertexID [[ vertex_id ]], // vertex_id是顶点shader每次处理的index，用于定位当前的顶点
             constant  ZJVertex*vertexArray [[ buffer(0) ]]) { // buffer表明是缓存数据，0是索引
    RasterizerData out;
    out.clipSpacePosition = vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    return out;
}

fragment float4
samplingShader(RasterizerData input [[stage_in]], // stage_in表示这个数据来自光栅化。（光栅化是顶点处理之后的步骤，业务层无法修改）
               texture2d<half> colorTexture [[ texture(0) ]]) // texture表明是纹理数据，0是索引
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear); // sampler是采样器 决定如何对一个纹理进行采样操作。寻址模式，过滤模式，归一化坐标，比较函数
    
    half4 colorSample = colorTexture.sample(textureSampler, input.textureCoordinate); // 得到纹理对应位置的颜色
    
    float4 color = float4(colorSample);
    return color;
}

fragment float4
lookUpTableShader(RasterizerData input [[stage_in]], // stage_in表示这个数据来自光栅化。（光栅化是顶点处理之后的步骤，业务层无法修改）
               texture2d<float> normalTexture [[ texture(LYFragmentTextureIndexNormal) ]], // texture表明是纹理数据，LYFragmentTextureIndexNormal是索引
               texture2d<float> lookupTableTexture [[ texture(LYFragmentTextureIndexLookupTable) ]]) // texture表明
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear); // sampler是采样器
    float4 textureColor = normalTexture.sample(textureSampler, input.textureCoordinate); //正常的纹理颜色
    
    float blueColor = textureColor.b * 63.0; // 蓝色部分[0, 63] 共64种
    
    float2 quad1; // 第一个正方形的位置, 假如blueColor=22.5，则y=22/8=2，x=22-8*2=6，即是第2行，第6个正方形；（因为y是纵坐标）
    quad1.y = floor(floor(blueColor) * 0.125);
    quad1.x = floor(blueColor) - (quad1.y * 8.0);
    
    float2 quad2; // 第二个正方形的位置，同上。注意x、y坐标的计算，还有这里用int值也可以，但是为了效率使用float
    quad2.y = floor(ceil(blueColor) * 0.125);
    quad2.x = ceil(blueColor) - (quad2.y * 8.0);
    
    float2 texPos1; // 计算颜色(r,b,g)在第一个正方形中对应位置
    texPos1.x = ((quad1.x * 64) +  textureColor.r*63 + 0.5)/512.0;
    texPos1.y = ((quad1.y * 64) +  textureColor.g*63 + 0.5)/512.0;
    
    
    float2 texPos2; // 同上
    texPos2.x = ((quad2.x * 64) +  textureColor.r*63 + 0.5)/512.0;
    texPos2.y = ((quad2.y * 64) +  textureColor.g*63 + 0.5)/512.0;
    
    float4 newColor1 = lookupTableTexture.sample(textureSampler, texPos1); // 正方形1的颜色值
    float4 newColor2 = lookupTableTexture.sample(textureSampler, texPos2); // 正方形2的颜色值
    
    float4 newColor = mix(newColor1, newColor2, fract(blueColor)); // 根据小数点的部分进行mix
    return float4(newColor.rgb, textureColor.w); //不修改alpha值
}


kernel void adjust_saturation(texture2d<float, access::read> inTexture [[texture(0)]],
                              texture2d<float, access::write> outTexture [[texture(1)]],
                              constant AdjustSaturationUniforms &uniforms [[buffer(0)]],
                              uint2 gid [[thread_position_in_grid]])
{
    float4 inColor = inTexture.read(gid);
    float value = dot(inColor.rgb, float3(0.299, 0.587, 0.114));
    float4 grayColor(value, value, value, 1.0);
    float4 outColor = mix(grayColor, inColor, uniforms.saturationFactor);
    outTexture.write(outColor, gid);
}


kernel void gaussian_blur_2d(texture2d<float, access::read> inTexture [[texture(0)]],
                             texture2d<float, access::write> outTexture [[texture(1)]],
                             texture2d<float, access::read> weights [[texture(2)]],
                             uint2 gid [[thread_position_in_grid]])
{
    int size = weights.get_width();
    int radius = size / 2;
    
    float4 accumColor(0, 0, 0, 0);
    for (int j = 0; j < size; ++j)
    {
        for (int i = 0; i < size; ++i)
        {
            uint2 kernelIndex(i, j);
            uint2 textureIndex(gid.x + (i - radius), gid.y + (j - radius));
            float4 color = inTexture.read(textureIndex).rgba;
            float4 weight = weights.read(kernelIndex).rrrr;
            accumColor += weight * color;
        }
    }
    outTexture.write(float4(accumColor.rgb, 1), gid);
}
