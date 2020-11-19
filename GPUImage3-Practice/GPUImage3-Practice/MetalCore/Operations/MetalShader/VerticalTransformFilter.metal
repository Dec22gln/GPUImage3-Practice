//
//  VerticalTransformFilter.metal
//  MIPKit
//
//  Created by 郭力楠 on 2019/7/8.
//  Copyright © 2019 郭力楠. All rights reserved.
//

#include <metal_stdlib>
#include "ShaderType.h"

using namespace metal;


vertex SingleInputVertexIO verticalTransformVertex(device packed_float2 *position [[buffer(0)]],
                                          device packed_float2 *texturecoord [[buffer(1)]],
                                          uint vid [[vertex_id]])
{
    
    float2 originalPosition = position[vid];
    
    float2 transformPosition = float2(originalPosition.x, - 1 * originalPosition.y);
    
    
    SingleInputVertexIO outputVertices;
    
    outputVertices.position = float4(transformPosition, 0, 1.0);
    outputVertices.textureCoordinate = texturecoord[vid];
    
    return outputVertices;
}
