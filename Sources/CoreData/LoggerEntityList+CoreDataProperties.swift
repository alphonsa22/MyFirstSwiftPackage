//
//  LoggerEntityList+CoreDataProperties.swift
//  
//
//  Created by Alphonsa Varghese on 25/06/23.
//
//

import Foundation
import CoreData
import MyFirstSwiftPackage

extension LoggerEntityList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoggerEntityList> {
        return NSFetchRequest<LoggerEntityList>(entityName: "LoggerEntityList")
    }

    @NSManaged public var loggers: Set<LoggerEntity>?

}

// MARK: Generated accessors for loggers
extension LoggerEntityList {

    @objc(addLoggersObject:)
    @NSManaged public func addToLoggers(_ value: LoggerEntity)

    @objc(removeLoggersObject:)
    @NSManaged public func removeFromLoggers(_ value: LoggerEntity)

    @objc(addLoggers:)
    @NSManaged public func addToLoggers(_ values: NSSet)

    @objc(removeLoggers:)
    @NSManaged public func removeFromLoggers(_ values: NSSet)

}
