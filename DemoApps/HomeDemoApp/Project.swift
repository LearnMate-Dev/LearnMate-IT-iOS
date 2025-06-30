import ProjectDescription

let project = Project(
    name: "HomeDemoApp",
    targets: [
        .target(
            name: "HomeDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.HomeDemoApp",
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
                .project(target: "Home", path: "../../Projects/Home"),
                .project(target: "Domain", path: "../../Projects/Domain"),
                .project(target: "Data", path: "../../Projects/Data"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "HomeDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.HomeDemoAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "HomeDemoApp")
            ]
        )
    ]
)
