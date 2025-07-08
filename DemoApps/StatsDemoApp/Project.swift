import ProjectDescription

let project = Project(
    name: "StatsDemoApp",
    targets: [
        .target(
            name: "StatsDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.StatsDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Stats", path: "../../Projects/Stats"),
                .project(target: "Domain", path: "../../Projects/Domain"),
                .project(target: "Data", path: "../../Projects/Data"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "StatsDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.StatsDemoAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "StatsDemoApp")
            ]
        )
    ]
)

