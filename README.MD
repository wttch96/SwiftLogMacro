为 swift-log 框架添加一个宏：`@Log`。

他会帮助在类内部生成一个 `logger: Logger`的变量，类似`@Slf4j`。

```swift
import SwiftLogMacro

@Log
class TestClass {
    init() {
        logger.info("TestClass init")
    }
}
```

宏展开之后为:
```swift
import SwiftLogMacro

class TestClass {
    private var logger = LogFactory.shared.createLogger(label: "TestCase")
    
    init() {
        logger.info("TestClass init")
    }
}
```
