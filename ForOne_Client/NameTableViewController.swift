//
//  NameTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/11.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit
class NameTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        nameTextField.text = myUser?.nickname
        saveButton.tintColor = lightColor
    }
    //MARK:保存
    @IBAction func save(sender: UIBarButtonItem) {
        
        guard let text = nameTextField.text else{
            return
        }
        
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            do{
                myUser?.nickname = text
                try context.save()
                
                navigationController?.popViewControllerAnimated(true)
            }catch let error{
                print("CoreData保存昵称错误: \(error)")
            }
        }
    }
}

extension NameTableViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        save(saveButton)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let existedLength = textField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        if existedLength! - selectedLength + replaceLength > 10{
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
        
        if sender.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 32{
            while sender.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 32 {
                
                let range = Range(sender.text!.startIndex..<sender.text!.endIndex.advancedBy(-1))
                sender.text = sender.text!.substringWithRange(range)
            }
        }
    }
}