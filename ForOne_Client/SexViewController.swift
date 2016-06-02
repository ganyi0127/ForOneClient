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
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //找到实体结构，并生成一个实体对象
        let row = NSEntityDescription.insertNewObjectForEntityForName("user", inManagedObjectContext: context)
        row.setValue(sex, forKey: "sex")
        do{
            try context.save()
        }catch let e{
            print(e)
        }
        
        
        //selectAll
        //构造查询对象
        let request = NSFetchRequest(entityName: "user")
//        let userDescription = NSEntityDescription.entityForName("user", inManagedObjectContext: context)
//        request.entity = userDescription
        do{
            
            let result = try context.executeFetchRequest(request)
            if !result.isEmpty {
                print(result)
            }
            try context.save()
        }catch let e{
            print(e)
        }
        
    
        let predicate = NSPredicate(format: "userid=1", 1)
        request.predicate = predicate
        do{
            
            let result = try context.executeFetchRequest(request)
            print(result)
            for obj in result {
                context.deleteObject(obj as! NSManagedObject)
            }
            try context.save()
        }catch let e{
            print(e)
        }
    }
}