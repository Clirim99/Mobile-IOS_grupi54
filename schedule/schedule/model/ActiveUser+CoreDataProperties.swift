//
//  ActiveUser+CoreDataProperties.swift
//  schedule
//
//  Created by user257547 on 2/29/24.
//
//

import Foundation
import CoreData


extension ActiveUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActiveUser> {
        return NSFetchRequest<ActiveUser>(entityName: "ActiveUser")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var user_id: User?

}

extension ActiveUser : Identifiable {

}
