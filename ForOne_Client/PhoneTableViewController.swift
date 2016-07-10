//
//  PhoneViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 7/10/16.
//  Copyright © 2016 gan. All rights reserved.
//

import UIKit
class PhoneTableViewController: UITableViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.text = "\(myUser?.telephone)"
        saveButton.tintColor = lightColor

    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        guard let text = phoneTextField.text else{
            return
        }
        
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            
            //判断是否为纯数字
            let noDigitText = text.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
            guard noDigitText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 else{
                errorAlert("号码只能包含阿拉伯数字噢")
                return
            }
            
            //判断号码是否为11位
            guard text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 11 else{
                errorAlert("号码长度需要为11位噢")
                return
            }
            
            do{
                myUser?.telephone = text
                try context.save()
                
                navigationController?.popViewControllerAnimated(true)
            }catch let error{
                print("CoreData保存电话错误: \(error)")
            }
        }
    }
    
    //MARK:错误提示
    private func errorAlert(title:String){
        let alertController = UIAlertController(title: "出错啦", message: title, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "我知道了", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension PhoneTableViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        save(saveButton)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let existedLength = textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if existedLength! - selectedLength + replaceLength > 11{
            return false
        }
        return true
    }
    
    @IBAction func editingChanged(sender: UITextField) {
        guard let _:String = sender.text else{
            return
        }
        
        if sender.text == myUser?.nickname {
            saveButton.tintColor = lightColor
        }else{
            saveButton.tintColor = darkColor
        }
        
        if sender.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 11{
            while sender.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 11 {
                
                sender.text = sender.text![sender.text!.startIndex..<sender.text!.endIndex.advancedBy(-1)]
            }
        }
    }
}
