//
//  TableViewExtension.swift
//  ForOne_Client
//
//  Created by YiGan on 7/9/16.
//  Copyright © 2016 gan. All rights reserved.
//

import UIKit
extension UIViewController{
    
    func presentFOPicker(foPickerView: FOPicker, completion: (() -> Void)?) {
        
        //判断是否含有FOPicker对象，有则先移除
        removeFOPickers()
        
        //移动动画
        let basicAnimation = CABasicAnimation(keyPath: "position.y")
        basicAnimation.fromValue = ViewSize.height
        basicAnimation.duration = 0.5
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        basicAnimation.fillMode = kCAFillModeBoth
        basicAnimation.beginTime = 0
        
        foPickerView.layer.addAnimation(basicAnimation, forKey: nil)
        
        view.addSubview(foPickerView)
        
        completion?()
    }
    
//    func viewDidDisappear(animated: Bool) {
//        
//        removeFOPickers()
//    }
    
    private func removeFOPickers(){
        
        for view in self.view.subviews{
            if view.isKindOfClass(FOPicker) {
                view.removeFromSuperview()
            }
        }
    }
}