import Foundation

func describeProjects(in proj: XcodeProjectlike, depth: Int = 0) {
    let pad = String(repeating: " ", count: depth)

    proj.projects.forEach {
        print("\(pad)\($0.name) (\($0.path.absolute().string))")
        describeProjects(in: $0, depth: depth + 2)
    }
}

do {
    let path = ProcessInfo.processInfo.arguments[1]
    let workspace = try Workspace(path: path)

    print("\nProject hierarchy:\n")
    describeProjects(in: workspace)
} catch {
    print("error: \(error)")
}

