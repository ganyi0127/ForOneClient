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
    
    override func viewDidLoad() {
        
    }
    
    //MARK:提交注册
    @IBAction func register(sender: UIButton) {
        
        accountTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        //账号密码注册
        let account:String = accountTextField.text!
        let password:String = passwordTextField.text!
        
        var body = [String:String]()
        body["username"] = account
        body["password"] = password
        Session.session("/register", body: body){
            success, result, reason in
            if success{
                
            }else{
                
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
        }
        return false
    }
}