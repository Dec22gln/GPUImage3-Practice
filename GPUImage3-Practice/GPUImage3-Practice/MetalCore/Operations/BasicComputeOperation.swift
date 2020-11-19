//
//  BasicComputeOperation.swift
//  SwiftTest
//
//  Created by 郭力楠 on 2020/11/2.
//  Copyright © 2020 郭力楠. All rights reserved.
//

import UIKit
import Metal

class BasicComputeOperation: ImageProcessingOperation {
    
    public let maximumInputs: UInt
    public let targets = TargetContainer()
    public let sources = SourceContainer()
    
    public var uniformSettings = ShaderUniformSettings()
    
    let computePipelineState: MTLComputePipelineState
    var inputTextures = [UInt:Texture]()
    let textureInputSemaphore = DispatchSemaphore(value:1)
    
    var textureHeap: MTLHeap?

    public init(computeFunctionName: String,
                numberOfInputs: UInt = 1) {
        
        self.maximumInputs = numberOfInputs
                
        guard let function =  sharedContext.defaultLibrary.makeFunction(name: computeFunctionName) else {
            fatalError("Could not compile compute function \(computeFunctionName)")
        }
        
        do {
            computePipelineState = try sharedContext.device.makeComputePipelineState(function: function)
        } catch  {
            fatalError("Could not compile compute Pipeline State \(computeFunctionName)")
        }
    }
    
    public func newTextureAvailable(_ texture: Texture, fromSourceIndex: UInt) {
        let _ = textureInputSemaphore.wait(timeout:DispatchTime.distantFuture)
        defer {
            textureInputSemaphore.signal()
        }

        inputTextures[fromSourceIndex] = texture
        
        if (UInt(inputTextures.count) >= maximumInputs) {
            let outputWidth: Int
            let outputHeight: Int
            
            let firstInputTexture = inputTextures[0]!
            outputWidth = firstInputTexture.texture.width
            outputHeight = firstInputTexture.texture.height
            
            if self.textureHeap == nil{
                makeHeap(size: CGSize(width: outputWidth, height: outputHeight))
            }
            
            if (self.textureHeap!.currentAllocatedSize <  outputWidth * outputHeight * 12 ){
                makeHeap(size: CGSize(width: outputWidth, height: outputHeight))
            }

            
            guard let commandBuffer = sharedContext.commandQueue.makeCommandBuffer() else {
                fatalError("Could not create render commandBuffer")
            }
            
            guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
                fatalError("Could not create render computeEncoder")
            }
            
            let groupSize = MTLSizeMake(16, 16, 1)
            let groupCountWidth = (outputWidth + groupSize.width - 1) / groupSize.width
            let groupCountHeight = (outputHeight + groupSize.height  - 1) / groupSize.height
            let threadgroupsPerGrid = MTLSizeMake(groupCountWidth, groupCountHeight, 1)
              
            let textureDescriptor = MTLTextureDescriptor.init()
            textureDescriptor.pixelFormat = MTLPixelFormat.r16Unorm
            textureDescriptor.width = outputWidth
            textureDescriptor.height = outputHeight
            textureDescriptor.usage = [.shaderRead,.shaderWrite,.renderTarget]
            
      
            guard let outputTexture = self.textureHeap!.makeTexture(descriptor: textureDescriptor) else{
                fatalError("Could not create outputTexture")
            }
            
            computeEncoder.setComputePipelineState(computePipelineState)
            computeEncoder.setTexture(firstInputTexture.texture, index: 0)
            computeEncoder.setTexture(outputTexture, index: 1)
    //        computeEncoder?.setBuffer(buffer, offset: 0, index: 0)
            
            computeEncoder.dispatchThreadgroups(threadgroupsPerGrid, threadsPerThreadgroup: groupSize)
            
            computeEncoder.endEncoding()
            
            let number = arc4random()
            
            print(" commit date : \(number)")
            
            commandBuffer.addScheduledHandler {_ in print( "commandBuffer Scheduled\(number)")}
                
            
            commandBuffer.addCompletedHandler { _ in print( "commandBuffer Completed\(number)") }

            print("usedSize:\(textureHeap!.usedSize/(1024*1024))M,currentAllocatedSize:\(textureHeap!.currentAllocatedSize/(1024*1024))Msize:\(textureHeap!.size/(1024*1024))M")
            commandBuffer.commit()
            
            
            updateTargetsWithTexture(Texture(texture: outputTexture))
        }
    }
    
    public func transmitPreviousImage(to target: ImageConsumer, atIndex: UInt) {
        // TODO: Finish implementation later
    }
    
    func makeHeap(size:CGSize){
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                         width: Int(size.width),
                                                                         height: Int(size.height),
                                                                         mipmapped: false)
        textureDescriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
        
        let sizeAndAlign = sharedContext.device.heapTextureSizeAndAlign(descriptor: textureDescriptor)
        let heapDescriptor = MTLHeapDescriptor()
        heapDescriptor.cpuCacheMode = .defaultCache
        heapDescriptor.storageMode = .shared
        heapDescriptor.size = sizeAndAlign.size * 3
        
        textureHeap = sharedContext.device.makeHeap(descriptor: heapDescriptor)
        
    }
}
