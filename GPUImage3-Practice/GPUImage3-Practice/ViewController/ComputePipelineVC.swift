//
//  ComputePipelineVC.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/23.
//

import UIKit

class ComputePipelineVC: BasicRendererVC {

    let picture = PictureInput.init(imageName: "timg")
    
    let enhancement = EnhancementCompute()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picture --> enhancement --> mtkView
        picture.processImage()
    }
    
}




