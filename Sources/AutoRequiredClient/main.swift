import AutoRequired
import Foundation

class A {
    var a: Int
    
    @AutoRequired init(a: Int) {
        self.a = a
    }
}
