//
//  AlertView.swift
//  ForOne_Client
//
//  Created by GAN-mac on 16/6/1.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit

class AlertView: NSObject {
   
    //MARK:验证帐号密码 提示框
    func showReloginAlert(){
        let alertView = UIAlertView(title: "登陆信息已过期", message: "请重新登陆", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "稍后", "登陆")
        alertView.alertViewStyle = .LoginAndPasswordInput
        alertView.show()
    }
    
    //MARK:创建一个loading视图，并返回
    class func createActivityIndicator(x: CGFloat, y:CGFloat) -> UIActivityIndicatorView{
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        loading.frame = CGRect(x: x - 12, y: y - 12, width: 24, height: 24)
        loading.startAnimating()
        loading.hidden = false
        return loading
    }

}

extension AlertView: UIAlertViewDelegate{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            //登陆
            let account = alertView.textFieldAtIndex(0)!.text!
            let password = alertView.textFieldAtIndex(1)!.text!
            
            var body = [String:String]()
            body["username"] = account
            body["password"] = password
            Session.session(Action.login, body: body){
                success, result, reason in
                if success{
                    let alertView = UIAlertView(title: nil, message: "验证登陆信息成功", delegate: nil, cancelButtonTitle: "我知道了")
                    alertView.show()
                    
                }else{
                    let alertView = UIAlertView(title: nil, message: "验证登陆信息失败", delegate: nil, cancelButtonTitle: "我知道了")
                    alertView.show()
                }
            }
        default:
            break
            
        }
    }
    
    
}