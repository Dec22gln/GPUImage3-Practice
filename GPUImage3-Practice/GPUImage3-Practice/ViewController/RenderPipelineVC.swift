//
//  RenderPipelineVC.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/23.
//

import UIKit

class RenderPipelineVC: BasicRendererVC {

    let picture = PictureInput.init(imageName: "timg")
    
    let windowLevels = WindowLevelsFilter()
    
    let verticalTransform = VerticalTransformFilter()
    
    let names = ["旋转","灰窗"]
    
    var isTransform = false
    var isWindowLevels = true
    
    /// 滤镜数组
    var filters = [BasicOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
    }
    
    
    func configVC()  {
        makeButtonWithTitles(titles: names)
        makeSlider(count: 2)
       
        //控制 windowLevels.maxValue 。
        let slider = sliders[0]
        slider.value = 1
        windowLevels.maxValue = 1
        windowLevels.minValue = 0
        
        updateAndShowcase()
    }
    
    override func buttonClick(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            isTransform = !isTransform
        case 1:
            isWindowLevels = !isWindowLevels
        default:
            break
        }
        updateAndShowcase()
    }
    
    func updateAndShowcase()  {
        updateOperation()
        picture.processImage()
    }
    
    func recoverOperation()  {
        picture.removeAllTargets()
        for item in filters {item.removeAllTargets()}
        filters.removeAll()
        
    }
    
    func updateOperation()  {
        
        recoverOperation()
        
        if isTransform { filters.append(verticalTransform) }
        if isWindowLevels { filters.append(windowLevels)}
        
        if filters.count < 1 {
            picture --> mtkView
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
