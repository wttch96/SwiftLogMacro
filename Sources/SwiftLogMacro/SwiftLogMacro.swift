// The Swift Programming Language
// https://docs.swift.org/swift-book

import Logging

/// 宏定义
@attached(member, names: named(logger))
public macro Log(_ name: String? = nil, level: Logger.Level = .info) = #externalMacro(module: "SwiftLogMacroMacros", type: "SwiftLogMacroMacros")
