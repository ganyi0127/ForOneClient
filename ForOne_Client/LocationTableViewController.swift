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
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "省份"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "\(indexPath.section)_\(indexPath.row)"
        let cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        cell.textLabel?.text = data[indexPath.row].0
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cityTableViewController = CityTableViewController(style: .Grouped)
        cityTableViewController.data = data[indexPath.row]
        navigationController?.pushViewController(cityTableViewController, animated: true)
    }
}