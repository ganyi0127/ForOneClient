//
//  RegisterViewController.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/1.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit
import CoreData
@IBDesignable
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBInspectable
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
//        passwordTextField.text?.rangeOfString("^[A-Za-z0-9]{6,20}+$", options: .RegularExpressionSearch, range: nil, locale: nil)
        //账号密码注册
        guard let account:String = accountTextField.text where account.characters.count >= 4 else{
            let alertView = UIAlertView(title: nil, message: "帐号太短啦", delegate: nil, cancelButtonTitle: "我知道了")
            alertView.show()
            return
        }
        
        guard let password:String = passwordTextField.text where (password.rangeOfString("^[A-Za-z0-9]{6,20}+$", options: .RegularExpressionSearch, range: nil, locale: nil) != nil) else{
            let alertView = UIAlertView(title: nil, message: "密码长度6~20咯", delegate: nil, cancelButtonTitle: "我知道了")
            alertView.show()
            return
        }
        
        guard let confirm:String = confirmTextField.text where password == confirm else{
            let alertView = UIAlertView(title: nil, message: "两组密码完全不一致啊 0_0", delegate: nil, cancelButtonTitle: "我知道了")
            alertView.show()
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
                
                do{
                    //储存到本地
                    let description = NSEntityDescription.entityForName("UserCD", inManagedObjectContext: context)
                    myUser = User(entity: description!, insertIntoManagedObjectContext: context)
                    myUser?.userid = Int32(result!["userid"]!)!
                    myUser?.tokenid = result!["tokenid"]
                    try context.save()
                }catch let error{
                    print("CoreData本地储存userid,tokenid出错:\(error)")
                }
                
                //载入性别选择
                let sexViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sexviewcontroller")
                self.showViewController(sexViewController, sender: self)
            }else{
                
                let alertView = UIAlertView(title: nil, message: reason!, delegate: nil, cancelButtonTitle: "我知道了")
                alertView.show()
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