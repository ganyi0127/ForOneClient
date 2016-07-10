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
        
        //修改viewWillDisappear
        var onceToken:dispatch_once_t = 0
        dispatch_once(&onceToken){
            let originSelector = #selector(UIViewController.viewWillDisappear(_:))
            let targetSelector = #selector(UIViewController.viewControllerWillDisappear(_:))
            
            let originMethod = class_getInstanceMethod(UIViewController.self, originSelector)
            let targetMethod = class_getInstanceMethod(UIViewController.self, targetSelector)
            
            method_exchangeImplementations(originMethod, targetMethod)
        }
        
        //判断是否含有FOPicker对象，有则先移除
        removeFOPickers()
        
        view.addSubview(foPickerView)
        
        //移动动画
        let basicAnimation = CABasicAnimation(keyPath: "position.y")
        basicAnimation.fromValue = ViewSize.height + view.frame.size.height / 2
        basicAnimation.duration = 1
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        basicAnimation.fillMode = kCAFillModeBoth
        basicAnimation.beginTime = 0
        
        foPickerView.layer.addAnimation(basicAnimation, forKey: nil)
        
        completion?()
        
        
    }
    
    public func viewControllerWillDisappear(animated: Bool){
        
        removeFOPickers()
    }
    
    private func removeFOPickers(){
        
        for view in self.view.subviews{
            if view.isKindOfClass(FOPicker) {
                view.removeFromSuperview()
            }
        }
    }
}

extension UIView{
    
    
}