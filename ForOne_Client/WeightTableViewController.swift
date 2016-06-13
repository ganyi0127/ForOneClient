//
//  WeightTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/12.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

class WeightTableViewController: UITableViewController {
    
    private var data = [Int]()
    
    override func viewDidLoad() {
        for i in 40...100{
            data.append(i)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "体重"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        cell.textLabel?.text = "\(data[indexPath.row])kg"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        do{
            myUser?.weight = Int32(data[indexPath.row])
            try context.save()
            navigationController?.popViewControllerAnimated(true)
        }catch let error{
            print("CoreData保存体重出错: \(error)")
        }
    }
}
