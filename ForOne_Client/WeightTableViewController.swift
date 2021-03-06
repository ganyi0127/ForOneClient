//
//  WeightTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/12.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

class WeightTableViewController: UITableViewController {
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightTextField.text = "\(myUser?.weight)"
        saveButton.tintColor = lightColor

    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        guard let text = weightTextField.text else{
            return
        }
        
        if text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            
            //判断是否为纯数字
            let noDigitText = text.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
            guard noDigitText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 else{
                errorAlert("体重只能输入阿拉伯数字噢")
                return
            }
            
            //判断体重范围为 10~200
            guard let weight = Int32(text) where weight > 10 && weight < 200 else{
                errorAlert("要输入正确的体重范围噢")
                return
            }
            
            do{
                myUser?.weight = weight
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

extension WeightTableViewController:UITextFieldDelegate{
    
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