//
//  PublicComputeKernel.metal
//  SwiftTest
//
//  Created by 郭力楠 on 2020/9/24.
//  Copyright © 2020 郭力楠. All rights reserved.
//

#include <metal_stdlib>
#include "GpuComputeKernelHeader.h"

using namespace metal;

PositionMatrix5x5 positionMatrix5x5(int x,int y){
    
    PositionMatrix5x5  outputVertices;
    //临域保护
    if (x <2 || y < 2){
        return outputVertices;
    }
    
    int2 ori = int2(x,y);

    outputVertices.m11 = ori - int2(2.0,2.0);
    outputVertices.m12 = ori - int2(1.0,2.0);
    outputVertices.m13 = ori - int2(0.0,2.0);
    outputVertices.m14 = ori - int2(-1.0,2.0);
    outputVertices.m15 = ori - int2(-2.0,2.0);

    outputVertices.m21 = ori - int2(2.0,1.0);
    outputVertices.m22 = ori - int2(1.0,1.0);
    outputVertices.m23 = ori - int2(0.0,1.0);
    outputVertices.m24 = ori - int2(-1.0,1.0);
    outputVertices.m25 = ori - int2(-2.0,1.0);

    outputVertices.m31 = ori - int2(2.0,0.0);
    outputVertices.m32 = ori - int2(1.0,0.0);
    outputVertices.m33 = ori;
    outputVertices.m34 = ori - int2(-1.0,0.0);
    outputVertices.m35 = ori - int2(-2.0,0.0);

    outputVertices.m41 = ori - int2(2.0,-1.0);
    outputVertices.m42 = ori - int2(1.0,-1.0);
    outputVertices.m43 = ori - int2(0.0,-1.0);
    outputVertices.m44 = ori - int2(-1.0,-1.0);
    outputVertices.m45 = ori - int2(-2.0,-1.0);

    outputVertices.m51 = ori - int2(2.0,-2.0);
    outputVertices.m52 = ori - int2(1.0,-2.0);
    outputVertices.m53 = ori - int2(0.0,-2.0);
    outputVertices.m54 = ori - int2(-1.0,-2.0);
    outputVertices.m55 = ori - int2(-2.0,-2.0);
    
    return outputVertices;
    
}

GrayColor_Float_Matrix5x5  get_color_floatMatrix5x5(int x,int y ,texture2d<float, access::read> sourceTexture){
    
    
    PositionMatrix5x5 position = positionMatrix5x5(x, y);
    
    GrayColor_Float_Matrix5x5 colorMatrix ;
    
    float4 colorTemp =  sourceTexture.read(uint2(position.m11));
    colorMatrix.m11 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m12));
    colorMatrix.m12 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m13));
    colorMatrix.m13 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m14));
    colorMatrix.m14 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m15));
    colorMatrix.m15 =colorTemp.r;
    
    colorTemp =  sourceTexture.read(uint2(position.m21));
    colorMatrix.m21 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m22));
    colorMatrix.m22 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m23));
    colorMatrix.m23 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m24));
    colorMatrix.m24 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m25));
    colorMatrix.m25 =colorTemp.r;
    
    
    colorTemp =  sourceTexture.read(uint2(position.m31));
    colorMatrix.m31 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m32));
    colorMatrix.m32 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m33));
    colorMatrix.m33 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m34));
    colorMatrix.m34 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m35));
    colorMatrix.m35 =colorTemp.r;
    
    colorTemp =  sourceTexture.read(uint2(position.m41));
    colorMatrix.m41 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m42));
    colorMatrix.m42 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m43));
    colorMatrix.m43 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m44));
    colorMatrix.m44 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m45));
    colorMatrix.m45 =colorTemp.r;
    
    colorTemp =  sourceTexture.read(uint2(position.m51));
    colorMatrix.m51 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m52));
    colorMatrix.m52 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m53));
    colorMatrix.m53 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m54));
    colorMatrix.m54 =colorTemp.r;
    colorTemp =  sourceTexture.read(uint2(position.m55));
    colorMatrix.m55 =colorTemp.r;
    
    return  colorMatrix;
}

float get_grayAverage_float5x5(GrayColor_Float_Matrix5x5 color){
    
    float total1 = color.m11 + color.m21 + color.m31 + color.m41 + color.m51;
    float total2 = color.m12 + color.m22 + color.m32 + color.m42 + color.m52;
    float total3 = color.m13 + color.m23 + color.m33 + color.m43 + color.m53;
    float total4 = color.m14 + color.m24 + color.m34 + color.m44 + color.m54;
    float total5 = color.m15 + color.m25 + color.m35 + color.m45 + color.m55;
    
    return (total1 + total2 + total3 + total4 + total5)/25;
}

float get_grayAverage_float3x3(GrayColor_Float_Matrix5x5 color){
    
    float total2 = color.m22 + color.m23 + color.m24 ;
    float total3 = color.m32 + color.m43 + color.m44 ;
    float total4 = color.m42 + color.m43 + color.m44 ;
    
    return ( total2 + total3 + total4 )/9;
}

