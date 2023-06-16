//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 15/06/23.
//

import Foundation
import os

enum LogEvent: String {
    case error = "‼️ "
    case info = "ℹ️ "
    case debug = "📝 "
    case verbose = "📣 "
    case warning = "⚠️ "
    case server = "🔥 "
}

///
func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print(object)
    #endif
}

public class Log {
    static var loggers = Logger()
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
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
    
    // MARK: - Loging methods
    
    
    /// Logs error messages on console with prefix [‼️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    public  class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column,     funcName: String = #function) {
        if isLoggingEnabled {
//            print("\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)")
            
            let logObject = "\(Date().toString()) \(LogEvent.error.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)"
            loggers.log(level: .error, "\(logObject,privacy: .public)")
            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
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
//            print("\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)")
            let logObject = "\(Date().toString()) \(LogEvent.info.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) : \(object)"
            loggers.log(level: .info, "\(logObject,privacy: .public)")
            self.saveLocally(str: "\(logObject) \n", fileName: "FinLog.log")
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
    public  class func d( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
//            print("\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
            
            let logObject = "\(Date().toString()) \(LogEvent.debug.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)"
            loggers.log(level: .debug, "\(logObject,privacy: .public)")
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
    public  class func v( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.verbose.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
            
//            let logObject = "\(Date().toString()) \(LogEvent.verbose.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)"
//            loggers.log(level: .debug, "\(logObject,privacy: .public)")
//            self.saveLocally(str: "\(object) \n", fileName: "FinLog.log")
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
    public  class func w( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.warning.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
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
    public  class func s( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(LogEvent.server.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) : \(object)")
        }
    }
    
    
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    public class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    public  class func saveLocally(str:String,fileName: String) {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
           

//            try str.write(to: fileURL, atomically: true, encoding: .utf8)
//            print("file url===",fileURL.path)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                     if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                        if #available(iOS 13.4, *) {
                             try fileHandle.seekToEnd()
                         } else {
                             fileHandle.seekToEndOfFile()
                             // Fallback on earlier versions
                         }
                         if let data = str.data(using: String.Encoding.utf8) {
                             fileHandle.write(data)
                         }
                         fileHandle.closeFile()
                     }
                 } else {
                     try str.write(to: fileURL, atomically: true, encoding: .utf8)
                 }
           
        } catch {
            print("JSONSave error of \(error)")
        }
    }
    
    public  class func getLogFileURL() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        let fileName = "\(dateString).log"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    public  class  func writeLogToFile(log: String) {
        let fileURL = getLogFileURL()
        
        do {
            try log.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Log saved successfully.")
        } catch {
            print("Error saving log: \(error.localizedDescription)")
        }
    }
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}

