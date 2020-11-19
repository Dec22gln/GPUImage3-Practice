//
//  ShaderType.h
//  MetalImageProcessing
//
//  Created by Colin on 2018/9/2.
//  Copyright © 2018年 Colin. All rights reserved.
//

#ifndef ShaderType_h
#define ShaderType_h
using namespace metal;

constant half3 luminanceWeighting = half3(0.2125, 0.7154, 0.0721);

struct SingleInputVertexIO
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
};

struct TwoInputVertexIO
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
    float2 textureCoordinate2 [[user(texturecoord2)]];
};

typedef struct
{
    vector_float4 position;
    vector_float2 textureCoordinate;
} LNVertex;


typedef enum LNVertexInputIndex
{
    LNVertexInputIndexVertices     = 0,
} LNVertexInputIndex;


typedef enum LNFragmentTextureIndex
{
    LNFragmentTextureIndexColorTextureSource     = 0,
    LNFragmentTextureIndexGrayTextureSource     = 1,
    LNFragmentTextureIndexTextureDest       = 2,
} LNFragmentTextureIndex;

typedef struct
{
    float maxValue;
    float minValue;
} LNWindowLevels;



//hue转成rgb
float hue2rgb( float p, float q, float rgb );
//根据索引值获得像素值
float4 rgbFromColotTable( uint index , bool isNormal);
//hls转成rgb
float4 hls2rgb(float hue, float lum, float sat);

#endif /* ShaderType_h */
