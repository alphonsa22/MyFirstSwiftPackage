//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 15/06/23.
//

import Foundation
import os
import CoreData

public enum LogEvent: String {
    case error = "‼️ "
    case info = "ℹ️ "
    case debug = "📝 "
    case verbose = "📣 "
    case warning = "⚠️ "
    case server = "🔥 "
}

public enum LogType: String {
    case debug
    case verbose
    case error
    case warning
    case server
}
///
func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print(object)
    #endif
}

public class AlpLog {
   public static var shared = AlpLog()
    static var dateFormat = "yyyy-MM-dd HH:mm" //yyyy-MM-dd hh:mm:ss
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    public static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
//    private static let persistentContainer: NSPersistentContainer = {
//           let container = NSPersistentContainer(name: "LoggerModel") // Replace with your CoreData model name
//           container.loadPersistentStores { _, error in
//               if let error = error as NSError? {
//                   fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
//               }
//           }
//           return container
//       }()
       
//    private static let persistentContainer: NSPersistentContainer = {
//        let bundle = Bundle.module
//        guard let modelURL = bundle.url(forResource: "LoggerModel", withExtension: "momd") else {
//            fatalError("Failed to locate Core Data model")
//        }
//        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("Failed to load Core Data model")
//        }
//        return NSPersistentContainer(name: "LoggerModel", managedObjectModel: model)
//    }()
    
  
    
    func getEntities() {
        let bundle = Bundle.module
        if let modelURL = bundle.url(forResource: "LoggerModel", withExtension: "momd") {
            // `YourDataModelFileName` is the name of your data model file without the extension (momd or xcdatamodeld)
            print("Data model URL: \(modelURL)")
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) // Replace `yourDataModelURL` with the URL of your data model file

            // Retrieve the list of entities from the managed object model
            if let entities = managedObjectModel?.entities {
                for entity in entities {
                    if let entityName = entity.name {
                        print("Entity: \(entityName)")
                        print("enity descriptio: \(entity.description)")
                        
                    }
                }
            }
        } else {
            print("Unable to locate data model URL.")
        }
        // Create a managed object model instance
     
    }
    
    private static func saveLogToDatabase(_ logMessage: String) {
        let context = CoreDataManager.shared.persistentContainer?.viewContext
        
            print("context===",context!)
           
           
           
        if let logEntity = NSEntityDescription.insertNewObject(forEntityName: "LoggerEntity", into: context!) as? LoggerEntity {
//            logEntity.timestamp = Date()
//            logEntity.message = logMessage
            
            print("success")
            
            let logEntity = LoggerEntity(context: context!)
            logEntity.timestamp = Date()
            logEntity.message = logMessage
            
            
            do {
              
                try? context!.save()
                try? context!.parent?.save()
                    print("successfully saved")
              
                let records = CoreDataManager.shared.fetchManagedObject(managedObject: LoggerEntity.self)
                print(records?.count)
 
            } catch {
                print("Error saving log to database: \(error)")
            }
        }
//
       }
    // MARK: - Loging methods
    public func log(level: LogType, _ message: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
            let formattedMessage = "[\(level.rawValue.uppercased())] \(Date()): \(message)"
        let logObject = "\(Date().toString()) [\(level.rawValue.uppercased())][\(AlpLog.sourceFileName(filePath: filename))]:\(line) \(funcName) : \(message)"
            print(logObject)
  //          saveLogToFile(formattedMessage)
  //      AlpLog.writeLogToFile(log: "\(logObject) \n")
        AlpLog.saveLogToDatabase(logObject)
//        getEntities()
        }
    
    /// Logs error messages on console with prefix [‼️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column,     funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)")
            
            let logObject = "\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)"
//            loggers.log(level: .error, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
            self.writeLogToFile(log: "\(logObject) \n")
        }
    }
    
    /// Logs info messages on console with prefix [ℹ️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public class func i ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function){
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)")
            let logObject = "\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)"
//            loggers.log(level: .info, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
            self.writeLogToFile(log: "\(logObject) \n")
        }
    }
    
    /// Logs debug messages on console with prefix [💬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public class func d( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
            
            let logObject = "\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)"
//            loggers.log(level: .debug, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
            self.writeLogToFile(log: "\(logObject) \n")
        }
    }
    
    /// Logs messages verbosely on console with prefix [🔬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public class func v( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.verbose.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
            
            let logObject = "\(Date().toString()) \(LogEvent.verbose.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)"
//            loggers.log(level: .debug, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
            self.writeLogToFile(log: "\(logObject) \n")
        }
    }
    
    /// Logs warnings verbosely on console with prefix [⚠️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public class func w( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
            let logObject = "\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)"
//            loggers.log(level: .debug, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
            self.writeLogToFile(log: "\(logObject) \n")
        }
    }
    
    /// Logs severe events on console with prefix [🔥]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public static func s( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.server.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
            let logObject = "\(Date().toString()) \(LogEvent.server.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)"
//            loggers.log(level: .debug, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
            self.writeLogToFile(log: "\(logObject) \n")
        }
    }
    
 
    
    
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
        
    private  class func getLogFileURL() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let fileName = "\(dateString).log"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    private class func getLogFileURLFromFolder() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let logDirectory = documentsDirectory.appendingPathComponent("Logs")
        
        // Create the Logs directory if it doesn't exist
        if !fileManager.fileExists(atPath: logDirectory.path) {
            do {
                try fileManager.createDirectory(at: logDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Failed to create log directory: \(error.localizedDescription)")
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let fileName = "\(dateString).log"
        let fileURL = logDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    private class func writeLogToFile(log: String) {
        let fileURL = getLogFileURLFromFolder()
        
        do {
//            try log.write(to: fileURL, atomically: true, encoding: .utf8)
//            print("Log saved successfully.")
            if FileManager.default.fileExists(atPath: fileURL.path) {
                     if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                         // to write in the same file
                        if #available(iOS 13.4, *) {
                             try fileHandle.seekToEnd()
                         } else {
                             fileHandle.seekToEndOfFile()
                             // Fallback on earlier versions
                         }
                         if let data = log.data(using: String.Encoding.utf8) {
                             fileHandle.write(data)
                         }
                         fileHandle.closeFile()
                         print("Log updated successfully.")
                     }
                 } else {
                     try log.write(to: fileURL, atomically: true, encoding: .utf8)
                     print("Log saved successfully.")
                 }
            
        } catch {
            print("Error saving log: \(error.localizedDescription)")
        }
    }
    

    

}

internal extension Date {
    func toString() -> String {
        return AlpLog.dateFormatter.string(from: self as Date)
    }
}

