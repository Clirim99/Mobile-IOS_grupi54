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
    @NSManaged public var spendings: NSSet?

}

// MARK: Generated accessors for spendings
extension User {

    @objc(addSpendingsObject:)
    @NSManaged public func addToSpendings(_ value: Spending)

    @objc(removeSpendingsObject:)
    @NSManaged public func removeFromSpendings(_ value: Spending)

    @objc(addSpendings:)
    @NSManaged public func addToSpendings(_ values: NSSet)

    @objc(removeSpendings:)
    @NSManaged public func removeFromSpendings(_ values: NSSet)

}

extension User : Identifiable {

}
