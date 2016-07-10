//
//  HeightTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/12.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

class HeightTableViewController: UITableViewController {
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightTextField.text = "\(myUser?.height)"
        saveButton.tintColor = lightColor

    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        guard let text = heightTextField.text else{
            return
        }
        
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            
            //判断是否为纯数字
            let noDigitText = text.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
            guard noDigitText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 else{
                errorAlert("身高只能输入阿拉伯数字噢")
                return
            }
            
            //判断体重范围为 40~250
            guard let height = Int32(text) where height > 40 && height < 250 else{
                errorAlert("要输入正确的身高范围噢")
                return
            }
            
            do{
                myUser?.height = height
                try context.save()
                
                navigationController?.popViewControllerAnimated(true)
            }catch let error{
                print("CoreData保存体重错误: \(error)")
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

extension HeightTableViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        save(saveButton)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let existedLength = textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if existedLength! - selectedLength + replaceLength > 3{
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
        
        if sender.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 3{
            while sender.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 3 {
                
                sender.text = sender.text![sender.text!.startIndex..<sender.text!.endIndex.advancedBy(-1)]
            }
        }
    }
}
