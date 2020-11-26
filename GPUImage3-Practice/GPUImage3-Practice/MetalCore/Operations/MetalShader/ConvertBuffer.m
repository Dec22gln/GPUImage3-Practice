//
//  ConvertBuffer.m
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/26.
//

#import "ConvertBuffer.h"

@implementation ConvertBuffer


+ (void )Convertbuffer:(void *)source  convertBuffer:(void *)desti sum:(int)sum{
    LYLocalBuffer *buffer = (LYLocalBuffer *)source; // GPU统计的结果
    LYLocalBuffer *convertBuffer = (LYLocalBuffer *)desti; // 颜色转换的buffer
    
    int val[3] = {0}; // 累计和
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 256; ++j) {
            val[i] += buffer->channel[i][j]; // 当前[0, j]累计出现的总次数
            convertBuffer->channel[i][j] = val[i] * 1.0 * (256 - 1) / sum;
        }
    }
    
}


@end
