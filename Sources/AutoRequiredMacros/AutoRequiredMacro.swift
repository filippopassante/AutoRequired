import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct AutoRequiredMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard declaration.is(InitializerDeclSyntax.self) else {
            let diagnostic = Diagnostic(
                node: node,
                message: MacroDiagnostic.notAnInit,
                fixIt: .replace(
                    message: MacroFixItMessage.notAnInit,
                    oldNode: node,
                    newNode: AttributeSyntax(stringLiteral: "")
                )
            )
            context.diagnose(diagnostic)
            return []
        }
        
        return try [DeclSyntax(InitializerDeclSyntax("required init?(coder: NSCoder)") {
            "fatalError(\"init(coder:) has not been implemented\")"
        })]
    }
}

@main
struct MacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoRequiredMacro.self
    ]
}

enum MacroDiagnostic: String, DiagnosticMessage {
    case notAnInit

    var message: String {
        switch self {
        case .notAnInit:
            "@AutoRequired can only be attached to initializers"
        }
    }
    
    var diagnosticID: MessageID {
        .init(domain: "AutoRequiredMacros", id: rawValue)
    }
    
    var severity: DiagnosticSeverity {
        .error
    }
}

enum MacroFixItMessage: String, FixItMessage {
    case notAnInit

    var message: String {
        switch self {
        case .notAnInit:
            "Remove '@AutoRequired '"
        }
    }
    
    var fixItID: MessageID {
        .init(domain: "AutoRequiredMacros", id: rawValue)
    }
}
