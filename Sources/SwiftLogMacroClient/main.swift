import SwiftLogMacro

@Log
class TestClass {
    init() {
        logger.info("TestClass")
        logger.debug("TestClass")
    }
}

@Log("测试Label")
class TestLabelClass {
    init() {
        logger.info("TestClass")
        logger.debug("TestClass")
    }
}

@Log("测试", level: .debug)
struct StructTest {
    init() {
        logger.debug("TestStruct")
    }
}

let a = TestClass()
let b = StructTest()
let c = TestLabelClass()
