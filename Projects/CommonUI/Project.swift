import ProjectDescription

let project = Project(
    name: "CommonUI",
    targets: [
        .target(
            name: "CommonUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.CommonUI",
            sources: ["Sources/**"],
            resources: ["Sources/Assets/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .external(name: "SnapKit"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        )
    ]
)
