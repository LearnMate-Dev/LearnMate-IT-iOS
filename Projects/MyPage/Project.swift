import ProjectDescription

let project = Project(
    name: "MyPage",
    targets: [
        .target(
            name: "MyPage",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.MyPage",
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Common", path: "../Common"),
                .project(target: "CommonUI", path: "../CommonUI"),
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "RxSwift")
            ]
        ),
        .target(
            name: "MyPageTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.MyPageTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "MyPage")
            ]
        )
    ]
)
