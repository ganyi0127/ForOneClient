//
//  FOPickerAction.swift
//  ForOne_Client
//
//  Created by YiGan on 7/10/16.
//  Copyright © 2016 gan. All rights reserved.
//

import UIKit
enum FOPickerActionType {
    case Default
    case Done
    case Cancel
}
class FOPickerAction: UIButton {
    
    private var closure:((result:String?)->())?
    var parentClosure:(()->())?
    
    //存储按钮点击返回值 cancel == nil
    var result:String?
    
    //存储按钮类型
    var type:FOPickerActionType?
    
    init(title:String, actionType:FOPickerActionType,completion:((result:String?)->())?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 46, height: 30))
        
        closure = completion
        
        setTitle(title, forState: .Normal)
        type = actionType
        
        config()
    }
    
    private func config(){
        
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        closure?(result:result)
        
        //移除上层view
        parentClosure?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}