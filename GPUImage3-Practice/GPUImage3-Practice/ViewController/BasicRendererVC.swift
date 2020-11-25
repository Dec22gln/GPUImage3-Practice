//
//  BasicRendererVC.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/19.
//

import UIKit

class BasicRendererVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
         setupMTKView()
        
        // Do any additional setup after loading the view.
    }
    
    var scrollView:UIScrollView?


    var mtkView:RenderView!
    
    func setupMTKView(){
        
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView?.bounces = false
        self.view.addSubview(scrollView!)
        
        mtkView = RenderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        //        mtkView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        
        self.scrollView!.addSubview(mtkView)
        
        
    }
    
    var buttons = [UIButton]()
    
    /// 根据titles创建多个button
    /// - Parameter titles: button的title
    func makeButtonWithTitles(titles:[String]){
        
        for index in 0...titles.count-1 {
            let button = UIButton(type: UIButton.ButtonType.system)
            button.frame = CGRect(x: 60 * index, y: 0, width: 60, height: 40)
            button.setTitle(titles[index], for: UIControl.State.normal)
            button.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControl.Event.touchUpInside)
            button.tag = index
            self.mtkView.addSubview(button)
            buttons.append(button)
            
        }
        
    }
    
    /// 快速创建button
    /// - Parameter count: 创建的个数
    func makeButton(count:Int) {
        
        var titles = [String]()
        for index in titles.count...titles.count+count {
            titles.append("button\(index)")
        }
        makeButtonWithTitles(titles: titles)
    }
    
    @objc func buttonClick(sender:UIButton){
        
        
    }

   
    var sliders = [UISlider]()
    
    func makeSlider(count:Int) {
    
        for count in 0...count-1 {
            let slider = UISlider(frame: CGRect(x: 30, y: 40 + 60 * count, width: Int(UIScreen.main.bounds.width - 60), height: 60))
            self.mtkView.addSubview(slider)
            slider.maximumValue = 1.0
            slider.minimumValue = 0.0
            slider.tag = count
            slider.addTarget(self, action: #selector(sliderDidChange(slider:)), for: UIControl.Event.valueChanged)
            sliders.append(slider)
        }
    }
    
    @objc func sliderDidChange(slider:UISlider) {
        
    }
    
    
    
}
