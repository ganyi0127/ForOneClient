//
//  LocationTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/12.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit
class LocationTableViewController: UITableViewController  {
    
    private let data = PlistSource.getCity()
    override func viewDidLoad() {
        print(data)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].1.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        cell.textLabel?.text = data[indexPath.section].1[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        do{
            myUser?.location = "\(data[indexPath.section].0)/\(data[indexPath.section].1[indexPath.row])"
            try context.save()
            navigationController?.popViewControllerAnimated(true)
        }catch let error{
            print("CoreData保存位置错误: \(error)")
        }
    }
}