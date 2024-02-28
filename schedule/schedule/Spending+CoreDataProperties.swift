//
//  Spending+CoreDataProperties.swift
//  schedule
//
//  Created by user257547 on 2/28/24.
//
//

import Foundation
import CoreData


extension Spending {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spending> {
        return NSFetchRequest<Spending>(entityName: "Spending")
    }

    @NSManaged public var cost: Double
    @NSManaged public var product_name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var buyer: User?
    @NSManaged public var product_type: ProductType?

}

extension Spending : Identifiable {

}
