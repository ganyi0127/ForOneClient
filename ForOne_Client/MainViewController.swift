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
    
    @IBOutlet var noteLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    var activityIndicatorView:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        config()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    private func config(){
        NotifictionCenter.addObserver(self, selector: #selector(MainViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NotifictionCenter.addObserver(self, selector: #selector(MainViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        loginButton.layer.cornerRadius = loginButton.frame.size.width / 2
    }

    //MARK:注册，用于快速登陆时注册
    func register(sender: UIButton) {
        
    }
    
    //MARK:登陆
    @IBAction func login(sender: UIButton) {
        
        accountTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        if sender.tag==0 {
            //快速登录
            register(sender)
        }else{
            
            guard let account:String = accountTextField.text where !account.characters.isEmpty else{
                AlertView.showAlert(alertMessage: "要输入帐号 0_0", alertDelegate: nil)
                return
            }
            
            guard let password:String = passwordTextField.text where !password.characters.isEmpty else{
                AlertView.showAlert(alertMessage: "要输入密码 0_0", alertDelegate: nil)
                return
            }
            
            //添加loading视图
            if activityIndicatorView == nil {
                activityIndicatorView = AlertView.createActivityIndicator(loginButton.frame.size.width / 2, y: loginButton.frame.size.height / 2)
                loginButton.addSubview(activityIndicatorView!)
            }else{
                activityIndicatorView?.startAnimating()
            }
            
            //账号密码登录
            var body = [String:String]()
            body["username"] = account
            body["password"] = password
            Session.session(Action.login, body: body){
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    deinit{
        NotifictionCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NotifictionCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

extension MainViewController:UITextFieldDelegate{
    
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        let animations = {
            self.boxView.transform = CGAffineTransformMakeTranslation(0, -offset)
            self.noteLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
            self.noteLabel.hidden = false
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    //键盘回收
    func keyboardWillHide(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations = {
            self.boxView.transform = CGAffineTransformIdentity
            self.noteLabel.transform = CGAffineTransformIdentity
            self.noteLabel.hidden = true
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            textField.resignFirstResponder()
            login(loginButton)
        }
        return false
    }
}
