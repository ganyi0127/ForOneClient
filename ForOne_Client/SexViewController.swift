//
//  SexViewController.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/2.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit
import CoreData

class SexViewController: UIViewController {
    
    override func viewDidLoad() {
        
    }
    @IBAction func choiceSex(sender: UIButton) {
        var sex = ""
        if sender.tag == 0 {
            sex = "男"
        }else{
            sex = "女"
        }
        
        //纪录到coredata中
        let context = AppDelegate().managedObjectContext
        //找到实体结构，并生成一个实体对象
        let user = NSEntityDescription.insertNewObjectForEntityForName("user", inManagedObjectContext: context)
        
        user.setValue(sex, forKey: "sex")
    }
}