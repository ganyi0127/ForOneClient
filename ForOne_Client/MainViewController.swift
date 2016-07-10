//
//  ViewController.swift
//  ForOne_Client
//
//  Created by GAN-mac on 16/5/31.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit
@IBDesignable
class MainViewController: UIViewController {

    @IBOutlet var boxView: UIView!
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var noteLabel: UILabel!
    
    @IBInspectable
    @IBOutlet var loginButton: UIButton!
    var activityIndicatorView:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        config()
        
        //test3D
//        let rotate = CATransform3DMakeRotation(CGFloat(M_PI_2) / 6, 1, 0, 0)
//        view.layer.transform = CATransform3DPerspect(rotate, center: CGPoint(x: 0, y:0), disZ: 1000)
//
//        let anim = CABasicAnimation(keyPath: "position.x")
//        anim.fromValue = 0
//        anim.toValue = view.bounds.size.width
//        anim.duration = 3
//        anim.beginTime = CACurrentMediaTime() + 1
//        anim.fillMode = kCAFillModeBoth
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        view.layer.addAnimation(anim, forKey: nil)
//
//        view.layer.opacity = 1
//        
//        let keyAnim = CAKeyframeAnimation()
//        keyAnim.duration = 3
//        keyAnim.autoreverses = true
//        keyAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    }
    
    private func CATransform3DMakePerspective(center:CGPoint, disZ:CGFloat) -> CATransform3D{
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
        let transBack = CATransform3DMakeTranslation(0, 0, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1/disZ
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
    }
    
    private func CATransform3DPerspect(t:CATransform3D, center:CGPoint, disZ:CGFloat) -> CATransform3D{
        return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ: disZ))
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
            //快速登录 直接载入
            let mainTabBar = contentStoryboard.instantiateViewControllerWithIdentifier("maintabbar")
            self.showViewController(mainTabBar, sender: nil)
        }else{
            
            guard let account:String = accountTextField.text where !account.characters.isEmpty else{
                let alertController = UIAlertController(title: nil, message: "要输入帐号 0_0", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            guard let password:String = passwordTextField.text where !password.characters.isEmpty else{
                let alertController = UIAlertController(title: nil, message: "要输入密码 0_0", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                presentViewController(alertController, animated: true, completion: nil)
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
                    let mainTabBar = contentStoryboard.instantiateViewControllerWithIdentifier("maintabbar")
                    self.showViewController(mainTabBar, sender: nil)
                    
                }else{
                   
                    let alertController = UIAlertController(title: nil, message: reason!, preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
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
