import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(AutoRequiredMacros)
import AutoRequiredMacros

let testMacros: [String: Macro.Type] = [
    "AutoRequired": AutoRequiredMacro.self
]
#endif

final class AutoRequiredTests: XCTestCase {
    func test_autoRequired() throws {
#if canImport(AutoRequiredMacros)
        assertMacroExpansion(
            """
class A {
    @AutoRequired init() {
    
    }
}
""",
            expandedSource: """
class A {
    init() {
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
""",
            macros: testMacros
        )
#else
throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    
// MARK: --
    func test_autoRequired_onFunction_shouldProduceTheExpectedDiagnostics() throws {
#if canImport(AutoRequiredMacros)
        assertMacroExpansion(
            "@AutoRequired func a() { }",
            expandedSource: "func a() { }",
            diagnostics: [.init(
                id: .init(domain: "AutoRequiredMacros", id: "notAnInit"),
                message: "@AutoRequired can only be attached to initializers",
                line: 1,
                column: 1,
                severity: .error,
                fixIts: [.init(message: "Remove '@AutoRequired '")]
            )],
            macros: testMacros
        )
#else
throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}

