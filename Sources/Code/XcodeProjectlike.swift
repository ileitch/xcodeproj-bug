import Foundation
import PathKit

public protocol XcodeProjectlike {
    var path: Path { get }
    var type: String { get }
    var name: String { get }
    var sourceRoot: Path { get }
    var projects: [Project] { get }
}

public extension XcodeProjectlike {
    var name: String {
        return path.lastComponentWithoutExtension
    }
}
