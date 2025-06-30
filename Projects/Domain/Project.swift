import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Domain",
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
