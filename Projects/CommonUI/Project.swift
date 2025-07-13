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
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .external(name: "SnapKit"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        )
    ]
)
