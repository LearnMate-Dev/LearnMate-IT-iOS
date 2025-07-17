import ProjectDescription

let project = Project(
    name: "Stats",
    targets: [
        .target(
            name: "Stats",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Stats",
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Common", path: "../Common"),
                .project(target: "CommonUI", path: "../CommonUI"),
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "RxSwift")
            ]
        ),
        .target(
            name: "StatsTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.StatsTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Stats")
            ]
        )
    ]
)
