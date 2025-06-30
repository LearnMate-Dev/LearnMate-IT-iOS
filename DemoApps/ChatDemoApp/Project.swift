import ProjectDescription

let project = Project(
    name: "ChatDemoApp",
    targets: [
        .target(
            name: "ChatDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ChatDemoApp",
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
                .project(target: "Chat", path: "../../Projects/Chat"),
                .project(target: "Domain", path: "../../Projects/Domain"),
                .project(target: "Data", path: "../../Projects/Data"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "ChatDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ChatDemoAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "ChatDemoApp")
            ]
        )
    ]
)

