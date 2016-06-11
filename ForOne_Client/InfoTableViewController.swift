//
//  infoTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/11.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var constellationLabel: UILabel!
    @IBOutlet weak var bloodtypeLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nameLabel.text = myUser?.nickname ?? "..."
        locationLabel.text = myUser?.location ?? "..."
        heightLabel.text = myUser?.height == nil ? "..." : "\(myUser!.height)"
        weightLabel.text = myUser?.weight == nil ? "..." : "\(myUser!.weight)"
        ageLabel.text = myUser?.age == nil ? "..." : "\(myUser!.age)"
        constellationLabel.text = myUser?.constellation ?? "..."
        bloodtypeLabel.text = myUser?.bloodtype ?? "..."
        telephoneLabel.text = myUser?.telephone ?? "..."
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            
            return "ID: \(myUser!.userid)    用户名: \(myUser!.username!)"
        }
        return "其他"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 1 {
            
        }else{
            switch row {
            case 0:
                //昵称
                let nameTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("nametableviewcontroller")
                navigationController?.pushViewController(nameTableViewController, animated: true)
            case 1:
                //地区
                let nameTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("locationtableviewcontroller")
                navigationController?.pushViewController(nameTableViewController, animated: true)
            default:
                let nameTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("nametableviewcontroller")
                navigationController?.pushViewController(nameTableViewController, animated: true)
            }
        }
    }
}
