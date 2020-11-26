//
//  HistogramEqualizationFilter.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/25.
//

import Foundation
import Metal

public class HistogramEqualizationFilter: BasicHeapOperation {
    
    public var colorTable: PictureInput!
    
    @objc public init() {
     
        super.init(fragmentFunctionName:"histogramEqualizationFragment", numberOfInputs:2)

        let textureDescriptor = MTLTextureDescriptor.init()
        textureDescriptor.pixelFormat = .r32Sint
        textureDescriptor.width = 256
        textureDescriptor.height = 3
        textureDescriptor.usage = [.shaderRead,.shaderWrite]
        
        let texture = sharedContext.device.makeTexture(descriptor: textureDescriptor)
        colorTable = PictureInput(texture: texture!)
        colorTable.addTarget(self, atTargetIndex:1)
        colorTable.processImage()
    }
}
