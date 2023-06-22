//
//  LoggerEntity+CoreDataClass.swift
//  
//
//  Created by Alphonsa Varghese on 22/06/23.
//
//

import Foundation
import CoreData


public class LoggerEntity: NSManagedObject {
    func convertToLoggerEntity() -> LoggerMDL {
        return LoggerMDL(timestamp: self.timestamp, message: self.message)
    }
}
