//
//  Configure.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/1.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation

let NotifictionCenter = NSNotificationCenter.defaultCenter()
let UserDefaults = NSUserDefaults.standardUserDefaults()

//host
let homehost = "http://192.168.1.101:8080"
let nethost = "http://127.0.0.1:8080"
let workhost = "http://192.168.1.127:8080"

//actions
struct Action{
    static let register = "/register"
    static let login = "/login"
    static let getInfo = "/getinfo"
    static let setInfo = "/setinfo"
}