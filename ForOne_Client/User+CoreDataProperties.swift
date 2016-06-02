//
//  User+CoreDataProperties.swift
//  ForOne_Client
//
//  Created by ganyi on 16/6/2.
//  Copyright © 2016年 gan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var tokenid: NSNumber?
    @NSManaged var username: String?
    @NSManaged var password: String?
    @NSManaged var sex: UNKNOWN_TYPE
    @NSManaged var nickname: String?
    @NSManaged var age: NSNumber?
    @NSManaged var location: String?
    @NSManaged var constellation: String?
    @NSManaged var height: NSNumber?
    @NSManaged var weight: NSNumber?
    @NSManaged var bloodtype: String?
    @NSManaged var telephone: String?
    @NSManaged var personality: String?

}
