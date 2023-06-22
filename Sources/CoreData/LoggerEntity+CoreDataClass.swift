//
//  LoggerEntity+CoreDataClass.swift
//  
//
//  Created by Alphonsa Varghese on 22/06/23.
//
//

import Foundation
import CoreData

@objc(LoggerEntity)
public class LoggerEntity: NSManagedObject {
    func convertToLoggerEntity() -> LoggerMDL {
        return LoggerMDL(timestamp: self.timestamp, message: self.message)
    }
}
