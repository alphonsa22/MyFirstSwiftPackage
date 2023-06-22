//
//  TestEntiry+CoreDataProperties.swift
//  
//
//  Created by Alphonsa Varghese on 22/06/23.
//
//

import Foundation
import CoreData


extension TestEntiry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntiry> {
        return NSFetchRequest<TestEntiry>(entityName: "TestEntiry")
    }

    @NSManaged public var test: String?

}
