//
//  User+CoreDataProperties.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/3.
//  Copyright © 2016年 gan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var age: Int32
    @NSManaged var bloodtype: String?
    @NSManaged var constellation: String?
    @NSManaged var height: Int32
    @NSManaged var location: String?
    @NSManaged var nickname: String?
    @NSManaged var password: String?
    @NSManaged var personality: String?
    @NSManaged var sex: String?
    @NSManaged var telephone: String?
    @NSManaged var tokenid: String?
    @NSManaged var userid: Int32
    @NSManaged var username: String?
    @NSManaged var weight: Int32

}
