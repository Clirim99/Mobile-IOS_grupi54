//
//  User+CoreDataProperties.swift
//  schedule
//
//  Created by user257547 on 2/28/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var first_name: String?
    @NSManaged public var user_id: UUID?
    @NSManaged public var last_name: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?

}

extension User : Identifiable {

}
