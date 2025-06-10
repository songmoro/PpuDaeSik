import ProjectDescription

let project = Project(
    name: "Tests",
    targets: [
        .target(
            name: "Tests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "com.moro.PpuDaeSikTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
//            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
