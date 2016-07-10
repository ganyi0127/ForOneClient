//
//  FOPickerView.swift
//  ForOne_Client
//
//  Created by YiGan on 7/9/16.
//  Copyright © 2016 gan. All rights reserved.
//

import UIKit
enum FOPickerDataType {
    case Constellation
    case BloodType
}
class FOPicker: UIView {
    
    let height = ViewSize.height * 0.3
    
    private var dataType:FOPickerDataType?
    private var data:[String]{
        
        var data = [String]()
        
        switch dataType! {
        case .Constellation:
            
            data = ["摩羯座",
                    "水瓶座",
                    "双鱼座",
                    "白羊座",
                    "金牛座",
                    "双子座",
                    "巨蟹座",
                    "狮子座",
                    "处女座",
                    "天枰座",
                    "天蝎座",
                    "射手座"]
        case .BloodType:
            
            data = ["A",
                    "B",
                    "AB",
                    "O"]
        }
        return data
    }
    
    //用于接收到点击时调用
    private var closure:(()->())?
    
    //选择器
    var pickView:UIPickerView?

    init(pickerType:FOPickerDataType, didSelect:(()->())?){
        super.init(frame: CGRect(x: 0, y: ViewSize.height - height, width: ViewSize.width, height: height))
        
        backgroundColor = lightColor
        
        dataType = pickerType
        closure = didSelect
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        pickView = UIPickerView(frame: CGRect(x: 0, y: 0, width: ViewSize.width, height: height))
        pickView?.delegate = self
        pickView?.dataSource = self
        pickView?.showsSelectionIndicator = true
        addSubview(pickView!)
        
    }
    
    //MARK:判断添加子view类型
    override func addSubview(view: UIView) {
        super.addSubview(view)
        
        if view.isKindOfClass(FOPickerAction) {
            
            let pickerAction = view as! FOPickerAction
            pickerAction.parentClosure = closure
            
            switch pickerAction.type! {
            case .Default:
                pickerAction.frame.origin = CGPoint(x: frame.size.width - view.frame.width ,
                                                    y: view.frame.height / 2)
            case .Done:
                pickerAction.result = data[pickView!.selectedRowInComponent(0)]
                pickerAction.frame.origin = CGPoint(x: frame.size.width - view.frame.width ,
                                                    y: view.frame.height / 2)
            case .Cancel:
                pickerAction.frame.origin = CGPoint(x: 0 ,
                                                    y: view.frame.height / 2)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FOPicker:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        for view in subviews{
            if view.isKindOfClass(FOPickerAction) && (view as! FOPickerAction).type == .Done {
                (view as! FOPickerAction).result = data[row]
            }
        }
    }
}