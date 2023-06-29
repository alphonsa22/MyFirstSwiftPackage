//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 15/06/23.
//

import Foundation
import os
import CoreData
import CommonCrypto

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
    
    private static func saveLogToDatabase(_ loggerArry: [LoggerMDL]) {
        let context = CoreDataManager.shared.persistentContainer?.viewContext
        
            print("context===",context!)
        
        
        CoreDataManager.shared.persistentContainer?.performBackgroundTask { newContext in
            
            let loggerEntityList = LoggerEntityList(context: newContext)
            loggerEntityList.loggers = []
            loggerArry.forEach { item in
                let perLogger = LoggerEntity(context: newContext)
                let encryptedData = self.encryptMessage(item.message ?? "no message")

                if let encryptedString = encryptedData?.base64EncodedString() {
                    perLogger.message  = encryptedString
                }
//                perLogger.message = item.message
                perLogger.timestamp = item.timestamp
                perLogger.loggerlist = loggerEntityList
            }
            
            do {
                if(newContext.hasChanges) {
                    try? newContext.save()
                    try newContext.parent?.save()
//                    self.fetchLoggerList()
                    self.fetchBasedOnSpecificDate()
                }
            } catch let error {
                print("Failed To Save:",error)
            }
            
        }
    }
    
    /*
     
     1. Fetch log data of a specific date
     2. Fetch log data of a date range
     3. Fetch all log data available in database
     4. Clear all log entries
     
     */
    
    
    private static func clearBD() {
        CoreDataManager.shared.clearDatabase()
    }

    private static func fetchLoggerList() -> [LoggerMDL] {
        
        let records = CoreDataManager.shared.fetchManagedObject(managedObject: LoggerEntity.self)
        print(records?.count)

        guard records != nil && records?.count != 0 else { return [] }
        
        var loggerMdlArry = [LoggerMDL]()
        records!.forEach { item in
//            print("item==",item.loggers ?? [])
//            let loggerItem = item.convertToLoggerList()
//            loggerMdlArry.append()
//            for item in loggerItem ?? [] {
//                loggerMdlArry.append(item)
//            }
            
            let timestamp = item.timestamp
            let message = self.decryptData(Data(base64Encoded: item.message ?? "") ?? Data())
           
            loggerMdlArry.append(LoggerMDL(timestamp: timestamp, message: message))
        }
        print("loggerMdlArry.count===",loggerMdlArry.count)
        print("loggerMdlArry===",loggerMdlArry)
        return loggerMdlArry
    }
    
    
    private static func fetchBasedOnSpecificDate() {
        let context = CoreDataManager.shared.persistentContainer?.viewContext
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let targetDateString = "2023-06-28"

        guard let targetDate = dateFormatter.date(from: targetDateString) else {
            fatalError("Failed to convert target date string to Date object.")
        }
        
        let fetchRequest: NSFetchRequest<LoggerEntity> = LoggerEntity.fetchRequest()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: targetDate)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        fetchRequest.predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startDate as NSDate, endDate! as NSDate)
        
        do {
            let logEntries = try context?.fetch(fetchRequest)
            
            print("logEntries.count===",logEntries?.count)
            // Process the fetched log entries
            for logEntry in logEntries ?? [] {
                let timestamp = logEntry.timestamp // Access the timestamp attribute
                let message = logEntry.message // Access the message attribute

                print("Timestamp: \(timestamp ?? Date()), Message: \(message ?? "")")
                
               
            }
        } catch {
            fatalError("Failed to fetch log entries: \(error)")
        }

    }
    
    
  private static func encryptMessage(_ message: String) -> Data? {
        guard let messageData = message.data(using: .utf8) else {
            return nil
        }
        
        var encryptedData = Data(count: messageData.count + kCCBlockSizeAES128)
        let keyData = "YourEncryptionKey".data(using: .utf8)! // Replace with your own encryption key
        
        let status = encryptedData.withUnsafeMutableBytes { encryptedBytes in
            messageData.withUnsafeBytes { messageBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES128,
                        nil,
                        messageBytes.baseAddress, messageBytes.count,
                        encryptedBytes.baseAddress, encryptedBytes.count,
                        nil
                    )
                }
            }
        }
        
        guard status == kCCSuccess else {
            return nil
        }
        
        return encryptedData
    }
    
    
    // MARK: - Loging methods
    public func log(level: LogType, _ message: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
            let formattedMessage = "[\(level.rawValue.uppercased())] \(Date()): \(message)"
        let logObject = "\(Date().toString()) [\(level.rawValue.uppercased())][\(AlpLog.sourceFileName(filePath: filename))]:\(line) \(funcName) : \(message)"
//            print(logObject)
  //          saveLogToFile(formattedMessage)
  //      AlpLog.writeLogToFile(log: "\(logObject) \n")
//        CoreDataManager.shared.clearDatabase()
        
        AlpLog.saveLogToDatabase([LoggerMDL(timestamp: Date(), message: logObject)])
//        AlpLog.clearBD()
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
    
  public static func decryptData(_ data: Data) -> String? {
        let keyData = "YourEncryptionKey".data(using: .utf8)! // Replace with your own encryption key
        
        var decryptedData = Data(count: data.count)
        let status = decryptedData.withUnsafeMutableBytes { decryptedBytes in
            data.withUnsafeBytes { encryptedBytes in
                keyData.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES128,
                        nil,
                        encryptedBytes.baseAddress, encryptedBytes.count,
                        decryptedBytes.baseAddress, decryptedBytes.count,
                        nil
                    )
                }
            }
        }
        
        guard status == kCCSuccess else {
            return nil
        }
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            return nil
        }
        
        return decryptedString
    }

    

}

internal extension Date {
    func toString() -> String {
        return AlpLog.dateFormatter.string(from: self as Date)
    }
}

