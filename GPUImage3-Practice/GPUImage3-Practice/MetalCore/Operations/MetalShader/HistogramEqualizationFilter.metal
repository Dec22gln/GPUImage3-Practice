//
//  HistogramEqualizationFilter.metal
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/25.
//

#include <metal_stdlib>
#import "ShaderType.h"

using namespace metal;

fragment half4
histogramEqualizationFragment(SingleInputVertexIO fragmentInput [[stage_in]],
                                                texture2d<half> inputTexture [[texture(0)]],
                                                texture2d<int> colorTableTexture [[texture(1)]])

{
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear); // sampler是采样器
    
    half4 color = inputTexture.sample(textureSampler, fragmentInput.textureCoordinate); // 得到纹理对应位置的颜色
    
    //取出每个通道的统计结果
    int sumR =   colorTableTexture.read(ushort2(color.r *255,0)).r ;
    int sumG =   colorTableTexture.read(ushort2(color.g *255,1)).r ;
    int sumB =   colorTableTexture.read(ushort2(color.b *255,2)).r ;
    
    //颜色转换
    half3 rgb = half3( sumR/255.0 , sumG/255.0 , sumB/255.0);

    return half4(rgb,color.a);
}






//kernel void postProcessing(texture2d<float, access::read> source[[texture(0)]],
//                           texture2d<float, access::write> dest[[texture(1)]],
//                           device HistogramColor *accHistogram [[buffer(0)]],
//                           uint2 gid [[thread_position_in_grid]]
//                           )
//{
//    if(gid.x >= source.get_width() || gid.y >= source.get_height()) return;
//
//    float4 source_color = source.read(gid);
//
//    ushort grayLevel = (ushort)(source_color.x * 255);
//
//    /* 直方图均衡化 */
//    int M = source.get_width();
//    int N = source.get_height();
//    // 均衡化直方图sk
//    HistogramColor sk[256];
//    float size = M * N;
//    for(int i = 1;i<256;++i){
//        sk[i].hr = round(255.0 * (accHistogram[i].hr / size));
//        sk[i].hg = round(255.0 * (accHistogram[i].hg / size));
//        sk[i].hb = round(255.0 * (accHistogram[i].hb / size));
//    }
//    // 均衡化直方图sk替换原图像灰度值
//    float r = sk[grayLevel].hr / 255.0;
//    float g = sk[grayLevel].hg / 255.0;
//    float b = sk[grayLevel].hb / 255.0;
//
//    float4 result_color = float4(r,g,b,0);
//
//    dest.write(result_color, gid);
//}
