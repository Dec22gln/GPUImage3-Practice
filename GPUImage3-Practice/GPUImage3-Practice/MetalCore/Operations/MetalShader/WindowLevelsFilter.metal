//
//  WindowLevels.metal
//  MetalImageProcessing
//
//  Created by 郭力楠 on 2019/2/27.
//  Copyright © 2019 Colin. All rights reserved.
//

#include <metal_stdlib>

#import "ShaderType.h"

using namespace metal;

typedef struct
{
    float maxValue;
    float minValue;
} WindowLevelsUniform;

fragment half4 windowLevelsFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                            texture2d<half> inputTexture [[texture(0)]],
                            constant WindowLevelsUniform& uniforms [[ buffer(1) ]])
{
    
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    
    half4 color = inputTexture.sample(textureSampler, fragmentInput.textureCoordinate); // 得到纹理对应位置的颜色
    
    half fGray = dot(color.bgr, luminanceWeighting);
        
    half grayMax = uniforms.maxValue;

    half grayMin = uniforms.minValue;

    if (fGray < grayMin){

        fGray = 0.0;
        
    }else if (fGray >grayMax){

        fGray = 1.0;

    }else{
        fGray = (fGray - grayMin)/(grayMax - grayMin);
    }
        
    return half4(half3(fGray),color.a);
    
}
