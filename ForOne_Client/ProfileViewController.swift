//
//  infoTableViewController.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/11.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    private struct Data {
        var profile = [(title:String,content:String)]()
        var biography:String?
    }
    private var data = Data(){
        didSet{
            tableview.reloadData()
        }
    }
    
    //pickers
    private var bloodTypePicker:FOPicker?
    private var constellationPicker:FOPicker?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        data.profile.removeAll()
        
        data.profile.append((title: "昵称", content: myUser?.nickname ?? "..."))
        data.profile.append((title: "地区", content: myUser?.location ?? "..."))
        data.profile.append((title: "身高", content: myUser?.height == nil ? "..." : "\(myUser!.height)cm"))
        data.profile.append((title: "体重", content: myUser?.weight == nil ? "..." : "\(myUser!.weight)kg"))
        data.profile.append((title: "年龄", content: myUser?.age == nil ? "..." : "\(myUser!.age)"))
        data.profile.append((title: "星座", content: myUser?.constellation ?? "..."))
        data.profile.append((title: "血型", content: myUser?.bloodtype ?? "..."))
        data.profile.append((title: "电话", content: myUser?.telephone ?? "..."))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.tintColor = darkColor
    }
    
    //MARK:完成注册
    @IBAction func finish(sender: UIBarButtonItem) {
        
        if myUser?.nickname == nil || myUser?.location == nil || myUser?.height == nil || myUser?.weight == nil || myUser?.age == nil || myUser?.constellation == nil || myUser?.bloodtype == nil || myUser?.telephone == nil {
            
            let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
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
                let mainTabBar = contentStoryboard.instantiateViewControllerWithIdentifier("maintabbar")
                self.presentViewController(mainTabBar, animated: true){}
            }else{
                let alertController = UIAlertController(title: nil, message: reason!, preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "我知道了", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return data.profile.count
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        default:
            return 155
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            
            return "ID: \(myUser!.userid)    用户名: \(myUser!.username!)"
        }
        return "其他"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell0") as! ProfileCell
            
            cell.titleLabel.text = data.profile[indexPath.row].title
            cell.contentLabel.text = data.profile[indexPath.row].content
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1") as! ContentCell
            cell.contentTextView.text = data.biography
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 1 {
            //简历
            
        }else{
            switch row {
            case 0:
                //昵称
                let nameTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("nametableviewcontroller")
                navigationController?.pushViewController(nameTableViewController, animated: true)
                
            case 1:
                //地区
                let locationTableViewController = LocationTableViewController(style: .Grouped)
                locationTableViewController.navigationItem.title = "区域"
                navigationController?.pushViewController(locationTableViewController, animated: true)
                
            case 2:
                //身高
                let heightTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("heighttableviewcontroller")
                navigationController?.pushViewController(heightTableViewController, animated: true)
                
            case 3:
                //体重
                let weightTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("weighttableviewcontroller")
                navigationController?.pushViewController(weightTableViewController, animated: true)
                
            case 4:
                //年龄
                let ageTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("agetableviewcontroller")
                navigationController?.pushViewController(ageTableViewController, animated: true)
                
            case 5:
                //星座
                constellationPicker = FOPicker(pickerType: .Constellation){
                    [weak self] in
                    
                    self!.constellationPicker?.removeFromSuperview()
                }
                presentFOPicker(constellationPicker!, completion: nil)
                
                let cancelAction = FOPickerAction(title:"取消", actionType: .Cancel){
                    _ in
                    
                }
                constellationPicker?.addSubview(cancelAction)
                
                let selectAction = FOPickerAction(title:"确定", actionType: .Done){
                    result in
                    
                    self.data.profile[indexPath.row].content = result ?? ""
                    
                    do{
                        
                        myUser?.constellation = result
                        try context.save()
                    }catch let error{
                        print("CoreData保存星座错误:\(error)")
                    }
                }
                constellationPicker?.addSubview(selectAction)
                
            case 6:
                //血型
                bloodTypePicker = FOPicker(pickerType: .BloodType){
                    [weak self] in
                    
                    self!.bloodTypePicker?.removeFromSuperview()
                }
                presentFOPicker(bloodTypePicker!, completion: nil)
                
                let cancelAction = FOPickerAction(title:"取消", actionType: .Cancel){
                    _ in
                    
                }
                bloodTypePicker?.addSubview(cancelAction)
                
                let selectAction = FOPickerAction(title:"确定", actionType: .Done){
                    result in
                    
                    self.data.profile[indexPath.row].content = result ?? ""
                    
                    do{
                        
                        myUser?.bloodtype = result
                        try context.save()
                    }catch let error{
                        print("CoreData保存血型错误:\(error)")
                    }
                }
                bloodTypePicker?.addSubview(selectAction)
                
            default:
                //电话
                let phoneTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("phonetableviewcontroller")
                navigationController?.pushViewController(phoneTableViewController, animated: true)
            }
        }
    }
}

extension ProfileViewController:UITextViewDelegate{
    
}
