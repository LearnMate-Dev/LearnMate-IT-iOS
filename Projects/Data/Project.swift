import ProjectDescription

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Data",
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
