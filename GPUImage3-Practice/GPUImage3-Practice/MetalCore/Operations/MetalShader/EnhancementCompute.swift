//
//  SharpeningCompute.swift
//  SwiftTest
//
//  Created by 郭力楠 on 2020/11/2.
//  Copyright © 2020 郭力楠. All rights reserved.
//

import UIKit

/// 转化为亮度图，暗的地方会更暗，亮的地方会更亮
class EnhancementCompute: BasicComputeOperation {
    
    public init() {
        super.init(computeFunctionName: "EnhancementCompute")
    }
}
