import ProjectDescription

let project = Project(
    name: "DiaryDemoApp",
    targets: [
        .target(
            name: "DiaryDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.DiaryDemoApp",
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
                .project(target: "Diary", path: "../../Projects/Diary"),
                .project(target: "Domain", path: "../../Projects/Domain"),
                .project(target: "Data", path: "../../Projects/Data"),
                .external(name: "Swinject")
            ]
        ),
        .target(
            name: "DiaryDemoAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DiaryDemoAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "DiaryDemoApp")
            ]
        )
    ]
)

