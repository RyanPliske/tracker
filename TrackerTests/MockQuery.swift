import Foundation
import Parse

class MockQuery: PFQuery {
    override func findObjectsInBackgroundWithBlock(block: PFArrayResultBlock?) {
        if let completionBlock = block {
            let record = MockRecord(className: "record", dictionary: ["Some Key" : "Some Value"])
            completionBlock([record], nil)
        }
    }
}