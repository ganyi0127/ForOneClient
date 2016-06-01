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
    
    var boxViewOriginFrame:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        config()
        
        boxViewOriginFrame = boxView.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    private func config(){
        NotifictionCenter.addObserver(self, selector: #selector(MainViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NotifictionCenter.addObserver(self, selector: #selector(MainViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
            Session.session("/login", body: body){
                success, result, reason in
                if success{
                   //载入
                    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let mainTabBar = storyboard.instantiateViewControllerWithIdentifier("maintabbar")
                    
                    

                }else{
                   
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
        }
        return false
    }
}
