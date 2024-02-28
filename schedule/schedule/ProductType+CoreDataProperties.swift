//
//  ProductType+CoreDataProperties.swift
//  schedule
//
//  Created by user257547 on 2/28/24.
//
//

import Foundation
import CoreData


extension ProductType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductType> {
        return NSFetchRequest<ProductType>(entityName: "ProductType")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type_name: String?
    @NSManaged public var desciption: String?

}

extension ProductType : Identifiable {

}
