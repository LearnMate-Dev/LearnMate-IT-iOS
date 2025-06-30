import ProjectDescription

let project = Project(
    name: "MyPageDemoApp",
    targets: [
        .target(
            name: "MyPageDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.MyPageDemoApp",
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
                .project(target: "MyPage", path: "../../Projects/MyPage"),
                .project(target: "Domain", path: "../../Projects/Domain"),
                .project(target: "Data", path: "../../Projects/Data"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "MyPageDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.MyPageDemoAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "MyPageDemoApp")
            ]
        )
    ]
)

