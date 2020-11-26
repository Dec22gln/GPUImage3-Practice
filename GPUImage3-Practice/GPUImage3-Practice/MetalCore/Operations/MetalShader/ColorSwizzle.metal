#include <metal_stdlib>
#include "ShaderType.h"

using namespace metal;

//rgba <--> gbra
fragment half4 colorSwizzleFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                   texture2d<half> inputTexture [[texture(0)]])
{
    constexpr sampler quadSampler;
    half4 color = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate).bgra;
    
    return color;
}

