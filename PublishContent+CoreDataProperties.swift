//
//  PublishContent+CoreDataProperties.swift
//  Adam
//
//  Created by 周岩峰 on 5/30/16.
//  Copyright © 2016 SwiftTai. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import CoreLocation

extension PublishContent {

    @NSManaged var userID: Int16
    @NSManaged var publishText: String?
    @NSManaged var grade: Int16
    @NSManaged var shopTitle: String
    @NSManaged var isAD: NSNumber
    @NSManaged var publishedPhoto: NSData
    @NSManaged var date: NSDate
    @NSManaged var location: CLLocation?

}
