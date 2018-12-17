import Foundation
import xcodeproj
import PathKit

public class Workspace: XcodeProjectlike {
    public let type: String = "workspace"
    public let path: Path
    public let sourceRoot: Path
    private let xcworkspace: XCWorkspace
    public var projects: [Project] = []

    required public init(path: String) throws {
        self.path = Path(path)
        self.sourceRoot = self.path.parent()

        do {
            self.xcworkspace = try XCWorkspace(pathString: self.path.absolute().string)
        } catch let error {
            throw TestError.underlyingError(error)
        }

        let projectPaths = collectProjectPaths(in: xcworkspace.data.children)
        projects = try projectPaths.map { try Project.make(path: (sourceRoot + $0).string) }
    }
}

private func collectProjectPaths(in elements: [XCWorkspaceDataElement]) -> [Path] {
    var paths: [Path] = []

    for child in elements {
        switch child {
        case .file(let ref):
            let path = Path(ref.location.path)
            if path.extension == "xcodeproj" {
                print("Found project at path '\(path)'")
                paths.append(path)
            }
        case .group(let group):
            paths += collectProjectPaths(in: group.children)
        }
    }

    return paths
}
