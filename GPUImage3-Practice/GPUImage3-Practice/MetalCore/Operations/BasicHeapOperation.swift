//
//  BaseHeapOperation.swift
//  OCSWIFT
//
//  Created by 郭力楠 on 2019/4/18.
//  Copyright © 2019 郭力楠. All rights reserved.
//

import Foundation
import MetalKit

open class BasicHeapOperation: BasicOperation {
    
    var textureHeap: MTLHeap?
    
    public override func newTextureAvailable(_ texture: Texture, fromSourceIndex: UInt) {
        let _ = textureInputSemaphore.wait(timeout:DispatchTime.distantFuture)
        defer {
            textureInputSemaphore.signal()
        }
        
        inputTextures[fromSourceIndex] = texture
        
        if (UInt(inputTextures.count) >= maximumInputs) {
            
            let outputWidth: Int
            var outputHeight: Int
            
            let firstInputTexture = inputTextures[0]!
            outputWidth = firstInputTexture.texture.width
            outputHeight = firstInputTexture.texture.height
            
            guard let commandBuffer = sharedContext.commandQueue.makeCommandBuffer() else {
                return
            }
            
            var outputTexture: Texture
            
            // 通过 MTLHeap 创建 MTLTexture ----------
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                             width: outputWidth,
                                                                             height: outputHeight,
                                                                             mipmapped: false)
            textureDescriptor.usage = [.renderTarget, .shaderRead]
            textureDescriptor.storageMode = .private
            
            if self.textureHeap == nil{
                makeHeap(size: CGSize(width: outputWidth, height: outputHeight))
            }
            
            if (self.textureHeap!.currentAllocatedSize <  outputWidth * outputHeight * 12 ){
                makeHeap(size: CGSize(width: outputWidth, height: outputHeight))
            }
            
            
            guard let newTexture = textureHeap?.makeTexture(descriptor: textureDescriptor) else {
                fatalError("textureHeap makeTexture error")
            }
            
            newTexture.makeAliasable()
            outputTexture = Texture.init(texture: newTexture)
            
            commandBuffer.renderQuad(pipelineState: renderPipelineState, uniformSettings: uniformSettings, inputTextures: inputTextures, outputTexture: outputTexture, clearColor: RenderColor.clearColor)
            commandBuffer.commit()
            
            updateTargetsWithTexture(outputTexture)
        }
    }
    
    func makeHeap(size:CGSize ,textureDescriptor:MTLTextureDescriptor? = nil ){
        print("makeHeap:\(size)")
        var descriptor = textureDescriptor
        
        if nil == descriptor {
            descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                  width: Int(size.width),
                                                                  height: Int(size.height),
                                                                  mipmapped: false)
            descriptor!.usage = [.renderTarget, .shaderRead ]
            descriptor?.storageMode = .private
        }
        
        
        let sizeAndAlign = sharedContext.device.heapTextureSizeAndAlign(descriptor: descriptor!)
        let heapDescriptor = MTLHeapDescriptor()
        //        heapDescriptor.cpuCacheMode = .writeCombined
        heapDescriptor.storageMode = .private
        heapDescriptor.size = sizeAndAlign.size
        
        textureHeap = sharedContext.device.makeHeap(descriptor: heapDescriptor)
        
    }
    
}
