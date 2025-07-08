import ProjectDescription

let project = Project(
    name: "LearnMate",
    targets: [
        .target(
            name: "LearnMate",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.LearnMate",
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
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Data", path: "../Data"),
                .project(target: "Home", path: "../Home"),
                .project(target: "Chat", path: "../Chat"),
                .project(target: "Diary", path: "../Diary"),
                .project(target: "MyPage", path: "../MyPage"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "LearnMateTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.LearnMateTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "LearnMate")]
        ),
    ]
)
