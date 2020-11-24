//
//  GpuComputeKernelHeader.h
//  SwiftTest
//
//  Created by 郭力楠 on 2020/8/25.
//  Copyright © 2020 郭力楠. All rights reserved.
//

#ifndef GpuComputeKernelHeader_h
#define GpuComputeKernelHeader_h

using namespace metal;

#define WORD unsigned short
#define WORDTYPE WORD
#define REALTYPE float
#define INTTYPE int
#define MOVEBYTE 8
#define MAX_INT 65535
#define MUTCOEFF 1
#define MAX_GRAY 65535

#define g_wBackgroundThreshold 65535

struct PositionMatrix5x5 {
    int2 m11 ;
    int2 m12 ;
    int2 m13 ;
    int2 m14 ;
    int2 m15 ;
    
    int2 m21 ;
    int2 m22 ;
    int2 m23 ;
    int2 m24 ;
    int2 m25 ;
    
    int2 m31 ;
    int2 m32 ;
    int2 m33 ;//原点
    int2 m34 ;
    int2 m35 ;
    
    int2 m41 ;
    int2 m42 ;
    int2 m43 ;
    int2 m44 ;
    int2 m45 ;
    
    int2 m51 ;
    int2 m52 ;
    int2 m53 ;
    int2 m54 ;
    int2 m55 ;
};

struct GrayColor_Float_Matrix5x5 {
    float m11 ;
    float m12 ;
    float m13 ;
    float m14 ;
    float m15 ;
    
    float m21 ;
    float m22 ;
    float m23 ;
    float m24 ;
    float m25 ;
    
    float m31 ;
    float m32 ;
    float m33 ;//原点
    float m34 ;
    float m35 ;
    
    float m41 ;
    float m42 ;
    float m43 ;
    float m44 ;
    float m45 ;
    
    float m51 ;
    float m52 ;
    float m53 ;
    float m54 ;
    float m55 ;
};
PositionMatrix5x5 positionMatrix5x5(int x,int y);

GrayColor_Float_Matrix5x5  get_color_floatMatrix5x5(int x,int y ,texture2d<float, access::read> sourceTexture);

//求平均数
float get_grayAverage_float5x5(GrayColor_Float_Matrix5x5 color);

float get_grayAverage_float3x3(GrayColor_Float_Matrix5x5 color);

#endif /* GpuComputeKernelHeader_h */
