//
//  PlistSource.swift
//  ForOne_Client
//
//  Created by YiGan on 16/6/12.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation

class PlistSource: NSObject {
    let path = NSBundle.mainBundle().pathForResource("City", ofType: "plist")
    class func getCity() -> [(String,[String])]{
        return PlistSource().readDictionary()
    }
    
    func documentPath() -> String{
        let documentpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentpath:AnyObject = documentpaths[0]
        return documentpath.stringByAppendingPathComponent("/City.plist")
    }
    
    func readDictionary() -> [(String,[String])]{
        let fileManager = NSFileManager.defaultManager()
        let fileExists = fileManager.fileExistsAtPath(documentPath())
        var dict:NSDictionary?
        if fileExists {
            dict = NSDictionary(contentsOfFile: documentPath())
        }else{
            dict = NSDictionary(contentsOfFile: path!)
        }

        var result = [(String,[String])]()
        for element in dict!{
            let key = String(element.key)
            let value = element.value as! NSArray
            var array = [String]()
            for city in value{
                array.append(city as! String)
            }
            result.append((key, array))
        }
        return result
    }
}