import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// 宏实现
public struct SwiftLogMacroMacros: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        var label: String? = nil
        // 获取参数
        if let argumentList = node.arguments?.as(LabeledExprListSyntax.self) {
            // 提取第一个参数（level）
            let labelArgument = argumentList.first?.expression
            label = labelArgument?.description.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            var declarationName: String? = declaration.as(ClassDeclSyntax.self)?.name.text
            declarationName = declarationName ?? declaration.as(StructDeclSyntax.self)?.name.text
            label = "\"\(declarationName ?? "Default")\""
        }

        // 默认使用类名作为 logger 标签
        let loggerLabel: String = label ?? "Default"

        // 生成 logger 属性，使用提供的 name 或默认的类名
        let loggerProperty = """
        private var logger = LogFactory.shared.createLogger(label: \(loggerLabel))
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
