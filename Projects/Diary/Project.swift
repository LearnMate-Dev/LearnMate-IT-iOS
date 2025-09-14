import ProjectDescription

let project = Project(
    name: "Diary",
    targets: [
        .target(
            name: "Diary",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Diary",
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Common", path: "../Common"),
                .project(target: "CommonUI", path: "../CommonUI"),
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "RxSwift"),
                .external(name: "FSCalendar")
            ]
        ),
        .target(
            name: "DiaryTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DiaryTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Diary")
            ]
        )
    ]
)
