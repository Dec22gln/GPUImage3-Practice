//
//  HistogramCompute.metal
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/23.
//

#include <metal_stdlib>
using namespace metal;

#define CHANNEL_NUM (3)
#define CHANNEL_SIZE (256)

constant float SIZE = float(CHANNEL_SIZE - 1);

//3通道 ，8位
typedef struct{
    atomic_uint channel[CHANNEL_NUM][CHANNEL_SIZE];
} HistogramBuffer;


kernel void
histogramKernel(texture2d<float, access::read>  sourceTexture  [[texture(0)]], // 纹理输入，
                device HistogramBuffer &out [[buffer(0)]], // 输出的buffer
                uint2  grid  [[thread_position_in_grid]]) // 格子索引
{
    // 边界保护
    if(grid.x < sourceTexture.get_width() && grid.y < sourceTexture.get_height())
    {
        float4 color  = sourceTexture.read(grid); // 初始颜色
        int3 rgb = int3(color.rgb * SIZE); // 乘以SIZE，得到[0, 255]的颜色值
        // 颜色统计，每个像素点计一次
        atomic_fetch_add_explicit(&out.channel[0][rgb.r], 1, memory_order_relaxed);
        atomic_fetch_add_explicit(&out.channel[1][rgb.g], 1, memory_order_relaxed);
        atomic_fetch_add_explicit(&out.channel[2][rgb.b], 1, memory_order_relaxed);
    }
}
