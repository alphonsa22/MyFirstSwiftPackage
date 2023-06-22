//
//  LoggerEntity+CoreDataProperties.swift
//  
//
//  Created by Alphonsa Varghese on 22/06/23.
//
//

import Foundation
import CoreData


extension LoggerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggerEntity> {
        return NSFetchRequest<LoggerEntity>(entityName: "LoggerEntity")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var message: String?

}
