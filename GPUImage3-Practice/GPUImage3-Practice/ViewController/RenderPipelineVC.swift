//
//  RenderPipelineVC.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/23.
//

import UIKit

class RenderPipelineVC: RendererVC {

    let picture = PictureInput.init(imageName: "timg")
    
    let windowLevels = WindowLevelsFilter()
    
    let verticalTransform = VerticalTransformFilter()
    
    let names = ["旋转","原色"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonWithTitles(titles: names)
        makeSlider(count: 2)
        
        windowLevels.maxValue = 1
        windowLevels.minValue = 0
        
        picture --> windowLevels --> mtkView
        filters.append(windowLevels)
        picture.processImage()
    }
    
    
    var isTransform = false
    var isOriginal = false
    var filters = [BasicOperation]()
    
    override func buttonClick(sender: UIButton) {
        picture.removeAllTargets()
        
        for item in filters {item.removeAllTargets()}
        filters.removeAll()
        
        switch sender.tag {
        case 0:
            isTransform = !isTransform
        case 1:
            isOriginal = !isOriginal
        default:
            break
        }
        updateOperation()
        picture.processImage()
    }
    
    
    func updateOperation()  {
        
        if isTransform { filters.append(verticalTransform) }
        if isOriginal == false { filters.append(windowLevels)}
        
        if filters.count < 1 {
            picture --> mtkView
            return
        }else{
            picture --> filters.first!
            filters.last! --> mtkView
            if filters.count == 1 { return }
            for index in 0...filters.count - 1 {
                if index == filters.count - 1 {continue}
                filters[index] --> filters[index + 1]
            }
        }
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
