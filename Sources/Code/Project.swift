import Foundation
import xcodeproj
import PathKit

public class Project: XcodeProjectlike {
    private static var cache: [String: Project] = [:]

    public static func make(path: String) throws -> Project {
        if let cached = cache[path] {
            return cached
        }

        return try self.init(path: path)
    }

    public let type: String = "project"
    public let path: Path
    public let sourceRoot: Path
    public let xcodeProject: XcodeProj
    public let name: String
    public var projects: [Project] = []

    required public init(path: String) throws {
        self.path = Path(path)
        self.name = self.path.lastComponentWithoutExtension
        self.sourceRoot = self.path.parent()

        do {
            print("Instantiating project at path '\(self.path.absolute().string)'")
            self.xcodeProject = try XcodeProj(pathString: self.path.absolute().string)
        } catch let error {
            throw TestError.underlyingError(error)
        }

        // Don't search for sub projects within CocoaPods.
        if path != "Pods/Pods.xcodeproj" {
            projects = try xcodeProject.pbxproj.fileReferences
                .filter { $0.path?.hasSuffix("xcodeproj") ?? false }
                .compactMap { try $0.fullPath(sourceRoot: sourceRoot) }
                .map { try Project.make(path: $0.string) }
        }

        Project.cache[path] = self
    }
}

extension Project: Hashable {
    public var hashValue: Int {
        return path.absolute().string.hashValue
    }
}

extension Project: Equatable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.path == rhs.path
    }
}
