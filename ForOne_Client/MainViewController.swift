//
//  ViewController.swift
//  ForOne_Client
//
//  Created by GAN-mac on 16/5/31.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var boxView: UIView!
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    @IBAction func register(sender: UIButton) {
    }
    
    @IBAction func login(sender: UIButton) {
        
        accountTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        if sender.tag==0 {
            //快速登录
        }else{
            //账号密码登录
            let account:String = accountTextField.text!
            let password:String = passwordTextField.text!
            
            var body = [String:String]()
            body["username"] = account
            body["password"] = password
            Session.session("/register", body: body){
                success, response in
                if success{
                    
                }else{
                    
                }
            }
        }
    }

}

extension MainViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        let textFieldHeight:CGFloat = textField.convertPoint(textField.frame.origin, toView: view).y
        let keyboardHeight:CGFloat = 258 + 20 // 252/216
        
        let offset:CGFloat = UIScreen.mainScreen().bounds.size.height - keyboardHeight > textFieldHeight ? 0 : textFieldHeight - (UIScreen.mainScreen().bounds.size.height - keyboardHeight)
        
        UIView.animateWithDuration(0.5, animations: {() -> Void in
            var frame:CGRect =  self.view.frame
            frame.origin.y = -offset
            self.view.frame = frame
            }, completion: { _ in
                
        })
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField==0{
            return false
        }else if textField==1{
            return true
        }
        return false
    }
}
