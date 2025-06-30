import ProjectDescription

let project = Project(
    name: "Common",
    targets: [
        .target(
            name: "Common",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Common",
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
