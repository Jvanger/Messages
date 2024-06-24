//
//  Contact+CoreDataProperties.swift
//  NewMessages
//
//  Created by Jonathan Fang on 6/24/24.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?

}

extension Contact : Identifiable {

}
