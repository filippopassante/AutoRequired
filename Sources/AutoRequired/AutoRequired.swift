///```
///@AutoRequired init() {
///
///}
///```
///Expands to:
///```
///init() {
///
///}
///
///required init?(coder: NSCoder) {
///    fatalError("init(coder:) has not been implemented")
///}
///```
@attached(peer, names: named(init(coder:)))
public macro AutoRequired() = #externalMacro(module: "AutoRequiredMacros", type: "AutoRequiredMacro")
