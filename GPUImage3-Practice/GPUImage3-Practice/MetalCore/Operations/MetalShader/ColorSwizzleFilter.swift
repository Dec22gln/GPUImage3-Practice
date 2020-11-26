//
//  ColorSwizzleFilter.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/25.
//

import Foundation

class ColorSwizzleFilter: BasicHeapOperation {
    
    public init() {
        super.init(fragmentFunctionName:"colorSwizzleFragment", numberOfInputs:1)
    }
}
