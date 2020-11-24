# GPUImage3-Practice

## Metal ##
Metal 是一个和 OpenGL ES 类似的面向底层的图形编程接口，可以直接操作GPU；支持iOS和OS X，提供图形渲染和通用计算能力。（现已支持模拟器）

## 环境 ##
MacOS Big Sur发布后就迫不及待的更新体验了，顺带的Xcode也更新了。- -
- Swift 5
- Xcode 12.2 
- iOS: 11.0 or higher

## 设计思想 ##
- 该框架依赖于处理流水线的概念，任意复杂的处理操作可以由一系列较小的操作组合而成。

- 这是一个面向对象的框架，包含封装输入、处理操作和输出的类。 处理操作使用Metal顶点和片元着色器在GPU上执行图像操作。

- 流程描述：
图片（PictureInput）-->n个滤镜（Operations）-->输出（RenderView）

## TODO ##

### shader ###
从GPUImage3中抽离出图像的部分，只研究学习如何使用Metal在App中做图像的处理。其中MetalShader可以从[GPUImage3](https://github.com/BradLarson/GPUImage3)中找到实现。
### 性能优化 ###
客户端的渲染在优化性能方面包括以下几部分工作：
- 选择正确的分辨率
- 最小化透明的过度绘制(overdraw)
- 尽可能早的向 GPU 提交任务
- 有效的传输资料
- 做好持续性能的设计

### 引入计算管线 ###
通用图形计算是general-purpose GPU，简称GPGPU。GPU可以用于加密、机器学习、金融等，图形绘制和图形计算并不是互斥的，Metal可以同时使用计算管道进行图形计算，并且用渲染管道进行渲染。

### 引入计算管线可能会遇到的问题 ###
Apple 的 GPU 有三个执行通道：顶点、片元和计算，这三者是并行执行的。三个通道各自服务于不同管线，互不干扰。但有些情况下，管线之间可能有数据依赖的，三个通道就会发生互相等待同步的过程。

所以当计算管线加入渲染流程的时候做了同步的处理，只有当计算完成后才会进行下一步：
```swift   
commandBuffer.addCompletedHandler { [self] _ in
                updateTargetsWithTexture(Texture(texture: outputTexture))
                textureInputSemaphore.signal()
}
```

### 内存占用优化 ###
每个Operation，或者说每个滤镜都会至少持有一个纹理。在高频率的渲染时，每个滤镜需要预先创建多个output纹理在队列中排队。也就是内存占用峰值将达到 （位图大小 * 滤镜数 * 3）。即使使用了MTLHeap已达到复用的目的也依然居高不下。