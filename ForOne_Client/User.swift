//
//  User.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/3.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    override func willSave() {
        print("willSave!")
    }
    override func didSave() {
        print("didSave!")
    }

}
