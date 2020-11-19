//
//  ViewController.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/19.
//

import UIKit

class ViewController: RendererVC {

    let picture = PictureInput.init(imageName: "timg")
    
    let windowLevels = WindowLevelsFilter()
    
    let verticalTransform = WindowLevelsFilter()
    
    let names = ["verticalTransform"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonWithTitles(titles: names)
        makeSlider(count: 2)
        
        windowLevels.maxValue = 1
        windowLevels.minValue = 0
        
        picture --> windowLevels --> mtkView
        picture.processImage()
    }
    
    
    
    
    override func sliderDidChange(slider: UISlider) {

        switch slider.tag {
        case 0:
            windowLevels.maxValue =  slider.value
        case 1:
            windowLevels.minValue =  slider.value
        default:
            print("null")
        }
        #if DEBUG
        print("MIN:",windowLevels.minValue,"  MAX:",windowLevels.maxValue)
        #endif
        picture.processImage()
    }
    

}

