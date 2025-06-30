import ProjectDescription

let project = Project(
    name: "Chat",
    targets: [
        .target(
            name: "Chat",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Chat",
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Common", path: "../Common"),
                .project(target: "CommonUI", path: "../CommonUI")
            ]
        ),
        .target(
            name: "ChatTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.ChatTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Chat")
            ]
        )
    ]
)
