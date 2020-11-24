//
//  CosEdgeEnhance.metal
//  SwiftTest
//
//  Created by 郭力楠 on 2020/8/25.
//  Copyright © 2020 郭力楠. All rights reserved.
//

#include <metal_stdlib>
#include "GpuComputeKernelHeader.h"
#import "ShaderType.h"

using namespace metal;

kernel void
EnhancementCompute(texture2d<float, access::read>  sourceTexture  [[texture(0)]], // 纹理输入，
                  texture2d<float, access::write> outputTexture  [[texture(1)]], // 纹理输出，
                  uint2                            grid         [[thread_position_in_grid]]) // 格子索引
{
    
    
    uint i = grid.x ;
    uint j = grid.y;
    
    // 边界保护
    if(i < sourceTexture.get_width() &&  j < sourceTexture.get_height())
    {
        
        float4 sourcePixel = sourceTexture.read(grid); //原纹理
        float3 luminanceWeighting = float3(0.2125, 0.7154, 0.0721);
        
        float nOriginGray = dot(sourcePixel.bgr, luminanceWeighting); //取灰度值
        
        if (nOriginGray >= 1)
        {
            outputTexture.write(sourcePixel, grid); // 写回对应纹理
            return;
        }
        
        uint stepNumber = 2;
        
        if (i <= stepNumber || j <=  stepNumber)
        {
            outputTexture.write(sourcePixel, grid); // 写回对应纹理
            return;
        }
        
        GrayColor_Float_Matrix5x5 color5x5 = get_color_floatMatrix5x5(int(i), int(j), sourceTexture);

        float medium = get_grayAverage_float5x5(color5x5);

        //稍稍增强
        float K = 3.0;
        
        float nResultGray = nOriginGray + (nOriginGray-medium) * K;
  
        outputTexture.write(float4(float3(nResultGray),sourcePixel.a), grid); // 写回对应纹理
    }
    
}


