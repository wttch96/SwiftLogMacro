//
//  LogFactory.swift
//  SwiftLogMacro
//
//  Created by Wttch on 2024/9/1.
//

import Foundation
import Logging

/// 由于宏展开暂时无法使用写入 import 语句，所以定义此类，帮助生成 Logger，由于该类是宏模块内部的，
/// 使用宏的时候一定会导入该类，宏展开后就可以直接调用而不会报错。
public final class LogFactory: Sendable {
    public static let shared = LogFactory()

    private init() {
        // 加载自定义的输出格式
        LoggingSystem.bootstrap(_LogHandler.init)
        print("已加载 SwiftLogMacro")
    }

    /// 帮助创建 Logger 对象
    public func createLogger(label: String) -> Logger {
        return Logger(label: label)
    }
}

/// 添加一个日志输出方法，格式类似 SpringBoot 默认格式。
/// 由于 xcode 输出不能输出带有颜色的文本，所以在日志最前面加上一个有色圆形: 🔵🟢🟠🟡🔴🟤等。
struct _LogHandler: LogHandler {
    var metadata: Logger.Metadata = .init()
    var logLevel: Logger.Level = .info
    var label: String
    
    /// 时间格式化为 yyyy-MM-dd HH:mm:ss.SSS
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
