//
//  ZJShaderTypes.h
//  Filter
//
//  Created by zhoujian on 2018/10/29.
//  Copyright © 2018年 zhoujian. All rights reserved.
//

#ifndef ZJShaderTypes_h
#define ZJShaderTypes_h


typedef struct {
    vector_float4 position;
    vector_float2 textureCoordinate;
}ZJVertex;

typedef enum LYFragmentTextureIndex
{
    LYFragmentTextureIndexNormal     = 0,
    LYFragmentTextureIndexLookupTable     = 1,
} LYFragmentTextureIndex;

#endif /* ZJShaderTypes_h */
