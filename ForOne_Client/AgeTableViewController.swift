//
//  AgeTabelViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 7/10/16.
//  Copyright © 2016 gan. All rights reserved.
//

import UIKit
class AgeTableViewController: UITableViewController {
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageTextField.text = "\(myUser?.age)"
        saveButton.tintColor = lightColor

    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        guard let text = ageTextField.text else{
            return
        }
        
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            
            //判断是否为纯数字
            let noDigitText = text.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
            guard noDigitText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 else{
                errorAlert("年龄只能输入阿拉伯数字噢")
                return
            }
            
            //判断年龄范围为 5~95
            guard let age = Int32(text) where age > 5 && age < 95 else{
                errorAlert("要输入正确的年龄范围噢")
                return
            }
            
            do{
                myUser?.age = age
                try context.save()
                
                navigationController?.popViewControllerAnimated(true)
            }catch let error{
                print("CoreData保存年龄错误: \(error)")
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

extension AgeTableViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        save(saveButton)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let existedLength = textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if existedLength! - selectedLength + replaceLength > 2{
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
        
        if sender.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 2{
            while sender.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 2 {
                
                sender.text = sender.text![sender.text!.startIndex..<sender.text!.endIndex.advancedBy(-1)]
            }
        }
    }
}