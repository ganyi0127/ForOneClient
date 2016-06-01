//
//  RegisterViewController.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/1.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    var activityIndicatorView:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        config()
    }
    
    private func config(){
        
        registerButton.layer.cornerRadius = registerButton.frame.size.width / 2
    }
    
    //MARK:提交注册
    @IBAction func register(sender: UIButton) {
        
        accountTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        //账号密码注册
        guard let account:String = accountTextField.text where account.characters.count >= 4 else{
            AlertView.showAlert(alertMessage: "帐号太短啦", alertDelegate: nil)
            return
        }
        
        guard let password:String = passwordTextField.text where password.characters.count >= 6 else{
            AlertView.showAlert(alertMessage: "请输入6位或以上的密码咯", alertDelegate: nil)
            return
        }
        
        guard let confirm:String = confirmTextField.text where password == confirm else{
            AlertView.showAlert(alertMessage: "两组密码完全不一致啊 0_0", alertDelegate: nil)
            return
        }
        
        //载入loading视图
        if activityIndicatorView == nil{
            activityIndicatorView = AlertView.createActivityIndicator(registerButton.frame.size.width / 2, y: registerButton.frame.size.height / 2)
            registerButton.addSubview(activityIndicatorView!)
        }else{
            activityIndicatorView?.startAnimating()
        }
        
        var body = [String:String]()
        body["username"] = account
        body["password"] = password
        Session.session("/register", body: body){
            success, result, reason in
            
            self.activityIndicatorView?.stopAnimating()
            
            if success{
                //载入
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let mainTabBar = storyboard.instantiateViewControllerWithIdentifier("maintabbar")
                self.showViewController(mainTabBar, sender: nil)
            }else{
                AlertView.showAlert(alertMessage: reason!, alertDelegate: nil)
            }
        }
        
    }
    
    @IBAction func dismiss(sender: UIButton) {
        
        dismissViewControllerAnimated(true){}
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        accountTextField.endEditing(true)
        passwordTextField.endEditing(true)
        confirmTextField.endEditing(true)
    }
}

extension RegisterViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            confirmTextField.becomeFirstResponder()
        }else if textField.tag == 2{
            textField.resignFirstResponder()
            register(registerButton)
        }
        return false
    }
}