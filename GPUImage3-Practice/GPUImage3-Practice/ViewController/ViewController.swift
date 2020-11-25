//
//  ViewController.swift
//  GPUImage3-Practice
//
//  Created by 郭力楠 on 2020/11/19.
//

import UIKit

struct item_vc {
    let title:String
    let detail:String
    let vc:UIViewController
}


class ViewController: BasicRendererVC {

    let tableView = UITableView()
    
    let dataSource = [item_vc(title: "渲染", detail: "通过渲染管线处理图像", vc:  RenderPipelineVC()),
                      item_vc(title: "灰度边缘增强", detail: "计算管线，模拟器会崩溃", vc:  ComputePipelineVC()),
                      item_vc(title: "官方滤镜", detail: "高度优化的常用滤镜", vc:  MPSImageFilterVC())]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Metal 图像处理"
        self.createTableView()
    }
    
    func createTableView(){
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(self.tableView)
    }
    
    func pushVC(info:item_vc){
        info.vc.modalPresentationStyle = .fullScreen
        info.vc.title = info.title
        self.navigationController?.pushViewController(info.vc, animated: true)
    }
}



extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = nil
        
        cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        
        cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        let info = dataSource[indexPath.row]
        
        cell?.textLabel?.text = indexPath.row < self.dataSource.count ? info.title:""
        cell?.detailTextLabel?.text = indexPath.row < self.dataSource.count ? info.detail:""
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let info = dataSource[indexPath.row]
        
        pushVC(info: info)
    }
}

