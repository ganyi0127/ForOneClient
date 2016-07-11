//
//  Configure.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/1.
//  Copyright © 2016年 gan. All rights reserved.
//

import UIKit

let NotifictionCenter = NSNotificationCenter.defaultCenter()
let UserDefaults = NSUserDefaults.standardUserDefaults()

//Size
let ViewSize = UIScreen.mainScreen().bounds.size
let StatusSize = UIApplication.sharedApplication().statusBarFrame.size

//CoreData
let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
var myUser:User?

//Storyboard
let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
let contentStoryboard = UIStoryboard(name: "Content", bundle: NSBundle.mainBundle())

//host
let homehost = "http://192.168.1.100:8080"
let localhost = "http://127.0.0.1:8080"
let workhost = "http://192.168.1.127:8080"

let host = localhost

//actions--HTTP
struct Action{
    static let register = "/register"
    static let login = "/login"
    static let getInfo = "/getinfo"
    static let setInfo = "/setinfo"
    static let getPhoto = "/getphoto"
    static let setPhoto = "/setphoto"
}

//男生女生颜色
struct Color{
    static let boyDark = UIColor(red: 125 / 255, green: 172 / 255, blue: 251 / 255, alpha: 1)
    static let boyLight = UIColor(red: 168 / 255, green: 219 / 255, blue: 255 / 255, alpha: 1)
    static let girlDark = UIColor(red: 255 / 255, green: 136 / 255, blue: 229 / 255, alpha: 1)
    static let girlLight = UIColor(red: 245 / 255, green: 170 / 255, blue: 249 / 255, alpha: 1)
}

var darkColor:UIColor?{
get{
    guard let user:User = myUser else{
        return UIColor.whiteColor()
    }
    if user.sex == "男"{
        return Color.boyDark
    }
    return Color.girlDark
}
}

var lightColor:UIColor? {
get{
    
    guard let user:User = myUser else{
        return UIColor.whiteColor()
    }
    if user.sex == "男"{
        return Color.boyLight
    }
    return Color.girlLight
}
}

//国际化
func Local(key:String) -> String{
    return NSLocalizedString(key, comment: key)
}


