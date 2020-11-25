//
//  MPSImageFilterVC.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/25.
//

import UIKit
import MetalPerformanceShaders
import MetalKit

class MPSImageFilterVC: BasicRendererVC {
    
    let picture = PictureInput.init(imageName: "timg")
    
    let device = sharedContext.device
    
    var sourceTexture:MTLTexture?
    var destinationTexture:MTLTexture?
    
    let names = ["原图","均衡"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeButtonWithTitles(titles: names)
        
        loadTexture()
        picture --> mtkView
        picture.processImage()
    }
    
    override func buttonClick(sender: UIButton) {
        
        switch sender.tag {
        case 0:showOrigi()
          
        case 1: process()
            
        default:
            break
        }
        
    }
    
    func showOrigi() {
        picture.updaTexture(texture: sourceTexture!)
        picture.processImage()
    }
    
    func loadTexture()  {
        let loader = MTKTextureLoader.init(device: device)
        
        do {
            try sourceTexture = loader.newTexture(name: "timg", scaleFactor: 1.0, bundle: .main, options: nil)
            
            let textureDescriptor = MTLTextureDescriptor.init()
            textureDescriptor.pixelFormat = sourceTexture!.pixelFormat
            textureDescriptor.width = sourceTexture!.width
            textureDescriptor.height = sourceTexture!.height
            textureDescriptor.usage = [.shaderRead,.shaderWrite,.renderTarget]
            destinationTexture =  device.makeTexture(descriptor: textureDescriptor)
            
        } catch {
            print("create texture error")
        }
        
        
    }
    
    /*
     在连线进行调试的时候 numberOfHistogramEntries: 256 会出现一个奇怪的断言：
     failed assertion `offset(4096) must be < [buffer length](4096). 拔了线再跑发现一切正常。
     
     在Stack Overflow中有人遇到相同的问题：
     这似乎是 MPSImageHistogramEqualization 中专用路径中的错误。
     当 numberOfHistogramEntries大于256时，图像内核会分配一个内部缓冲区，
     该缓冲区足够大以容纳需要处理的数据（对于N = 512，这是8192字节），加上额外的空间（32个字节）。
     设置内部 optimized256BinsUseCase 标志时，它将精确分配4096个字节，从而省去了最后的额外存储空间。
     我的怀疑是，后续操作依赖于初始数据块之后有更多空间，并且无意中将缓冲区偏移设置为超过内部缓冲区的长度。
     通过使用不同数量的直方图箱（例如512）来解决此问题。这浪费了一些空间和时间，但是我认为它将产生相同的结果。
     或者，您可以通过禁用Metal验证层来避免崩溃，但是我强烈不建议这样做，因为您将一直掩盖根本问题
     
     */
    var histogramInfo = MPSImageHistogramInfo(
        numberOfHistogramEntries: 256,//
        histogramForAlpha: false,
        minPixelValue: vector_float4(0,0,0,0),
        maxPixelValue: vector_float4(1,1,1,1))
    
    func process()  {
        
        let calculation = MPSImageHistogram(device: device,
                                            histogramInfo: &histogramInfo)
        
        let bufferLength = calculation.histogramSize(forSourceFormat: sourceTexture!.pixelFormat)
        
        guard let histogramInfoBuffer = device.makeBuffer(length: bufferLength,
                                                    options: [.storageModePrivate])else {
            fatalError("Could not create histogramInfoBuffer")
        }
        
        guard let commandBuffer = sharedContext.commandQueue.makeCommandBuffer()else {
            fatalError("Could not create commandBuffer")
        }
        
        calculation.encode(to: commandBuffer,
                           sourceTexture: sourceTexture!,
                           histogram: histogramInfoBuffer,
                           histogramOffset: 0)
        
        let equalization = MPSImageHistogramEqualization(device: device, histogramInfo: &histogramInfo)
        
        equalization.encodeTransform(to: commandBuffer, sourceTexture: sourceTexture!, histogram: histogramInfoBuffer, histogramOffset: 0)
        
        equalization.encode(commandBuffer: commandBuffer, sourceTexture: sourceTexture!, destinationTexture: destinationTexture!)
        
        commandBuffer.addCompletedHandler { [self] (buffer) in
            picture.updaTexture(texture: destinationTexture!)
            picture.processImage()
        }
        commandBuffer.commit()
        
    }
    
}
