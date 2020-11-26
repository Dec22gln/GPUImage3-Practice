//
//  ConvertBuffer.h
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef struct
{
    int channel[3][256]; // rgb三个通道，每个通道有256种可能
} LYLocalBuffer;

@interface ConvertBuffer : NSObject


+ (void )Convertbuffer:(void *)source  convertBuffer:(void *)desti sum:(int)sum;

@end

NS_ASSUME_NONNULL_END
