//
//  VerticalTransformFilter.swift
//  MIPKit
//
//  Created by 郭力楠 on 2019/7/8.
//  Copyright © 2019 郭力楠. All rights reserved.
//

import UIKit

/// 旋转180度！
class VerticalTransformFilter: BasicHeapOperation {

    public init() {
        super.init(vertexFunctionName: "verticalTransformVertex", fragmentFunctionName: "passthroughFragment", numberOfInputs: 1)
    }
    
    
}
