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
    
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        finishButton.tintColor = darkColor
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nameLabel.text = myUser?.nickname ?? "..."
        locationLabel.text = myUser?.location ?? "..."
        heightLabel.text = myUser?.height == nil ? "..." : "\(myUser!.height)cm"
        weightLabel.text = myUser?.weight == nil ? "..." : "\(myUser!.weight)kg"
        ageLabel.text = myUser?.age == nil ? "..." : "\(myUser!.age)"
        constellationLabel.text = myUser?.constellation ?? "..."
        bloodtypeLabel.text = myUser?.bloodtype ?? "..."
        telephoneLabel.text = myUser?.telephone ?? "..."
        tableView.reloadData()
    }
    
    //MARK:完成注册
    @IBAction func finish(sender: UIBarButtonItem) {
        if myUser?.nickname == nil || myUser?.location == nil || myUser?.height == nil || myUser?.weight == nil || myUser?.age == nil || myUser?.constellation == nil || myUser?.bloodtype == nil || myUser?.telephone == nil {
            
            let alertController = UIAlertController(title: nil, message: "获取头像", preferredStyle: .Alert)
            let backAction = UIAlertAction(title: "继续完善资料", style: .Default){
                action in
            }
            alertController.addAction(backAction)
            let laterAction = UIAlertAction(title: "稍后再说", style: .Default){
                action in
                self.next()
            }
            alertController.addAction(laterAction)
            presentViewController(alertController, animated: true){}
        }else{
            next()
        }
    }
    
    //MARK:保存
    private func next(){

        var body = [String:AnyObject]()
        body["userid"] = Int(myUser!.userid)
        body["tokenid"] = myUser!.tokenid
        body["nickname"] = myUser?.nickname ?? ""
        body["location"] = myUser?.location ?? ""
        body["sex"] = myUser!.sex
        body["height"] = myUser?.height == nil ? 0 : Int(myUser!.height)
        body["weight"] = myUser?.weight == nil ? 0 : Int(myUser!.weight)
        body["age"] = myUser?.age == nil ? 0 : Int(myUser!.age)
        body["constellation"] = myUser?.constellation ?? ""
        body["bloodtype"] = myUser?.bloodtype ?? ""
        body["telephone"] = myUser?.telephone ?? ""
        body["personality"] = myUser?.personality ?? ""
        Session.session(Action.setInfo, body: body){
            success, result, reason in
            if success{
                //载入
                let mainTabBar = mainStoryboard.instantiateViewControllerWithIdentifier("maintabbar")
                self.presentViewController(mainTabBar, animated: true){}
            }else{
                let alertController = UIAlertController(title: nil, message: reason!, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
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
                let locationTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("locationtableviewcontroller")
                navigationController?.pushViewController(locationTableViewController, animated: true)
            case 2:
                //身高
                let heightTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("heighttableviewcontroller")
                navigationController?.pushViewController(heightTableViewController, animated: true)
            case 3:
                //体重
                let weightTableViewController = WeightTableViewController(style: UITableViewStyle.Grouped)
                weightTableViewController.navigationItem.title = "体重"
                navigationController?.pushViewController(weightTableViewController, animated: true)
            default:
                let nameTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("nametableviewcontroller")
                navigationController?.pushViewController(nameTableViewController, animated: true)
            }
        }
    }
}
