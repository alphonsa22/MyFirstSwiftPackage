//
//  LoggerEntityList+CoreDataClass.swift
//  
//
//  Created by Alphonsa Varghese on 25/06/23.
//
//

import Foundation
import CoreData


public class LoggerEntityList: NSManagedObject {
    
    func convertToLoggerList() -> LoggerListMDL {
        
        return LoggerListMDL(loggers: self.convertToLogger())
    }
    
    func convertToLogger() -> [LoggerMDL]? {
        
        guard self.loggers != nil && self.loggers?.count != 0 else { return nil }
        var logger: [LoggerMDL] = []
        self.loggers?.forEach({ item in
            logger.append(item.convertToLoggerEntity())
        })
        return logger
    }
    
}
