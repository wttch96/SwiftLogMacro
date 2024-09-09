import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// 宏实现
public struct SwiftLogMacroMacros: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        var label: String? = nil
        var level = ".info"
        // 获取参数
        if let argumentList = node.arguments?.as(LabeledExprListSyntax.self) {
            // 提取第一个参数 label
            for arg in argumentList {
                if arg.label?.text == "label" {
                    // label 参数
                    // 这里会有引号
                    label = arg.expression.description.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                if arg.label?.text == "level" {
                    // level 参数
                    level = arg.expression.description.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }

            // 如果有类型注释，检查它是否为 "String"
            if label == nil, let firstArg = argumentList.first {
                if firstArg.label == nil {
                    // 空的 label
                    label = firstArg.expression.description.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        if label == nil {
            // 使用类名, 结构体名
            if let className = declaration.as(ClassDeclSyntax.self) {
                label = "\"\(className.name.text)\""
            }
            if let structName = declaration.as(StructDeclSyntax.self) {
                label = "\"\(structName.name.text)\""
            }
        }

        // 默认使用类名作为 logger 标签
        let loggerLabel: String = label ?? "\"Default\""

        // 生成 logger 属性，使用提供的 name 或默认的类名
        let loggerProperty = """
        private var logger = LogFactory.shared.createLogger(label: \(loggerLabel), level: \(level))
        """

        return try [
            DeclSyntax(VariableDeclSyntax(SyntaxNodeString(stringLiteral: loggerProperty))),
        ]
    }
}

@main
struct SwiftLogMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SwiftLogMacroMacros.self,
    ]
}
