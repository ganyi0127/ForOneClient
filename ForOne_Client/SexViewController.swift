//
//  SexViewController.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/2.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class SexViewController: UIViewController {
    
    @IBInspectable @IBOutlet weak var boyButton: UIButton!
    @IBInspectable @IBOutlet weak var girlButton: UIButton!
    
    override func viewDidLoad() {
        
        boyButton.layer.cornerRadius = boyButton.frame.size.width / 2
        girlButton.layer.cornerRadius = girlButton.frame.size.width / 2
    }
    @IBAction func choiceSex(sender: UIButton) {
        var sex = ""
        if sender.tag == 0 {
            sex = "男"
        }else{
            sex = "女"
        }

        do{
            //更新
            myUser?.sex = sex
            try context.save()
        }catch let error{
            print("CoreData保存性别出错:\(error)")
        }
        
        //载入照片选择
        let photoViewController = mainStoryboard.instantiateViewControllerWithIdentifier("photoviewcontroller")
        showViewController(photoViewController, sender: self)
        
    }
}