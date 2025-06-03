import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
//        .target(
//            name: "PpuDaeSikTests",
//            destinations: .iOS,
//            product: .unitTests,
//            bundleId: "io.tuist.PpuDaeSikTests",
//            infoPlist: .default,
//            sources: ["PpuDaeSik/Tests/**"],
//            resources: [],
//            dependencies: [.target(name: "PpuDaeSik")]
//        ),
    ]
)
