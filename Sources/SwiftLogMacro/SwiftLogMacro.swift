// The Swift Programming Language
// https://docs.swift.org/swift-book

import Logging

@attached(member, names: named(logger))
public macro Log(_ name: String? = nil) = #externalMacro(module: "SwiftLogMacroMacros", type: "SwiftLogMacroMacros")
