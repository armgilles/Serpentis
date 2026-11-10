import Foundation

struct TestFailure: Error, CustomStringConvertible {
    let description: String
}

func expect(_ condition: @autoclosure () -> Bool, _ message: String = "",
            file: StaticString = #filePath, line: UInt = #line) throws {
    guard condition() else {
        throw TestFailure(description: "\(file):\(line): expectation failed\(message.isEmpty ? "" : ": \(message)")")
    }
}

func require<T>(_ value: T?, file: StaticString = #filePath, line: UInt = #line) throws -> T {
    guard let value = value else {
        throw TestFailure(description: "\(file):\(line): required value is nil")
    }
    return value
}
