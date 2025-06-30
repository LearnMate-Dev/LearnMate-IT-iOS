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
            sources: ["LearnMate/Sources/**"],
            resources: ["LearnMate/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "LearnMateTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.LearnMateTests",
            infoPlist: .default,
            sources: ["LearnMate/Tests/**"],
            resources: [],
            dependencies: [.target(name: "LearnMate")]
        ),
    ]
)
