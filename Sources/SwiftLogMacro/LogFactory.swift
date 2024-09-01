//
//  LogFactory.swift
//  SwiftLogMacro
//
//  Created by Wttch on 2024/9/1.
//

import Foundation
import Logging

public final class LogFactory: Sendable {
    public static let shared = LogFactory()

    private init() {
        LoggingSystem.bootstrap(_LogHandler.init)
        print("已加载 SwiftLogMacro")
    }

    public func createLogger(label: String) -> Logger {
        return Logger(label: label)
    }
}

struct _LogHandler: LogHandler {
    var metadata: Logger.Metadata = .init()
    var logLevel: Logger.Level = .info
    var label: String
    
    private let dateFormatter: DateFormatter
    
    init(label: String) {
        self.label = label
        
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
    }

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        let timestamp = dateFormatter.string(from: Date())
        let processID = ProcessInfo.processInfo.processIdentifier
        let threadName = Thread.isMainThread ? "main" : Thread.current.name ?? "unknown"
        let loggerName = label
        let logLevel = level.rawValue.uppercased()

        let prefix = [
            Logger.Level.trace: "",
            .debug: "🔵",
            .info: "🟢",
            .notice: "🟠",
            .warning: "🟡",
            .error: "🔴",
            .critical: "🟤"
        ]

        let formattedMessage = "\(prefix[level] ?? "")\(timestamp) \(logLevel) \(processID) --- [\(threadName)] \(loggerName) : \(message)"
        print(formattedMessage)
    }

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}
