//
//  CityTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/12.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit
class CityTableViewController: UITableViewController {
    
    var data:(String,[String])?
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.1.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data!.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        cell.textLabel?.text = data?.1[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        do{
            myUser?.location = "\(data!.0)/\(data!.1[indexPath.row])"
            try context.save()
            navigationController?.popViewControllerAnimated(true)
            for viewController in navigationController!.viewControllers {
                if viewController.isKindOfClass(ProfileViewController) {
                    
                    navigationController?.popToViewController(viewController, animated: false)
                }
            }
        }catch let error{
            print("CoreData保存位置错误: \(error)")
        }
    }
}