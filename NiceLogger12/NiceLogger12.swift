//
//  NiceLogger.swift
//  NiceLogger12
//
//  Created by Rana Farooq on 21/07/2020.
//  Copyright © 2020 AmcoItSystems. All rights reserved.
//

import Foundation

enum LoggerLevel: Int {
    case info = 1
    case debug
    case warning
    case error
    case none
    
    var name: String {
        switch self {
        case .info: return "I"
        case .debug: return "D"
        case .warning: return "W"
        case .error: return "E"
        case .none: return "N"
        }
    }
}

enum LoggerOutput: String {
    case debuggerConsole
    case deviceConsole
}

class NiceLogger: NSObject {
    public static var tag: String?
    public static var level: LoggerLevel = .info
    public static var ouput: LoggerOutput = .debuggerConsole
    public static var showThread: Bool = false
    
    private override init() {
        super.init()
    }
    
    class func log(_ level: LoggerLevel, message: String, currentTime: Date, fileName: String , functionName: String, lineNumber: Int, thread: Thread) {
        
        guard level.rawValue >= self.level.rawValue else { return }
        
        let _fileName = fileName.split(separator: "/")
        let text = "\(showThread ? thread.description : "")[\(_fileName.last ?? "?")#\(functionName)#\(lineNumber)]\(tag ?? "")-\(level.name): \(message)"
        if self.ouput == .deviceConsole {
            NSLog(text)
        } else {
            print("\(currentTime.iso8601) \(text)")
        }
    }
    
     class func i(_ message: String, currentTime: Date = Date(), fileName: String = #file, functionName: String = #function, lineNumber: Int = #line, thread: Thread = Thread.current ) {
        log(.info, message: message, currentTime: currentTime, fileName: fileName, functionName: functionName, lineNumber: lineNumber, thread: thread)
    }
     class func d(_ message: String, currentTime: Date = Date(), fileName: String = #file, functionName: String = #function, lineNumber: Int = #line, thread: Thread = Thread.current ) {
        log(.debug, message: message, currentTime: currentTime, fileName: fileName, functionName: functionName, lineNumber: lineNumber, thread: thread)
    }
     class func w(_ message: String, currentTime: Date = Date(), fileName: String = #file, functionName: String = #function, lineNumber: Int = #line, thread: Thread = Thread.current ) {
        log(.warning, message: message, currentTime: currentTime, fileName: fileName, functionName: functionName, lineNumber: lineNumber, thread: thread)
    }
     class func e(_ message: String, currentTime: Date = Date(), fileName: String = #file, functionName: String = #function, lineNumber: Int = #line, thread: Thread = Thread.current ) {
        log(.error, message: message, currentTime: currentTime, fileName: fileName, functionName: functionName, lineNumber: lineNumber, thread: thread)
    }
}


extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    var secondsSince1970:Int {
        return Int((self.timeIntervalSince1970).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func getCurrentTimeString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let nowDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = Foundation.TimeZone(identifier: "UTC")
        //formatter.dateStyle = .MediumStyle
        //formatter.timeStyle = .MediumStyle
        return formatter.string(from: nowDate)
    }
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

 extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

 extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
