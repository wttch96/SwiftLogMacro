import SwiftLogMacro

@Log
class TestClass {
    init() {
        logger.info("TestClass")
    }
}

@Log("测试")
struct StructTest {
    init() {
        logger.info("TestStruct")
    }
}

let a = TestClass()
let b = StructTest()
