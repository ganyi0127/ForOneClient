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
        
        //设置title颜色为自定义颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
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
            
            //设置返回按钮颜色为自定义颜色
            navigationController?.navigationBar.tintColor = darkColor

            
            //载入照片选择
            let photoViewController = mainStoryboard.instantiateViewControllerWithIdentifier("photoviewcontroller")
            navigationController?.pushViewController(photoViewController, animated: true)
        }catch let error{
            print("CoreData保存性别错误:\(error)")
        }
        
    }
}