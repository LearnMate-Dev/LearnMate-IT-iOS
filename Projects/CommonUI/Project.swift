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
                .external(name: "SnapKit")
            ]
        )
    ]
)
