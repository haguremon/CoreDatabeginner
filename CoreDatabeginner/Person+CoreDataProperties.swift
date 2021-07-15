//
//  Person+CoreDataProperties.swift
//  CoreDatabeginner
//
//  Created by IwasakIYuta on 2021/07/15.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var email: String?
    @NSManaged public var name: String?

}

extension Person : Identifiable {

}
