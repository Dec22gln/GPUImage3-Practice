//
//  WindowLevelsFilter.swift
//  MetalImageProcessing
//
//  Created by 郭力楠 on 2019/2/27.
//  Copyright © 2019 Colin. All rights reserved.
//

import Foundation

/// 灰窗调节算法，多应用于医学影像
public class WindowLevelsFilter: BasicHeapOperation {
    
    ///使用时， 传 0 - 1的值，值为 1 无变换
    public var maxValue: Float = 0 {
        didSet {
            uniformSettings[0] = maxValue
        }
    }
    
    ///使用时， 传 0 - 1的值，值为 0 无变换
    public var minValue: Float = 1.0 {
        didSet {
            uniformSettings[1] = minValue
        }
    }
    
   @objc public init() {
        super.init(fragmentFunctionName:"windowLevelsFragment", numberOfInputs:1)
        
        uniformSettings.appendUniform(0)
        uniformSettings.appendUniform(1.0)
    
    }
}
