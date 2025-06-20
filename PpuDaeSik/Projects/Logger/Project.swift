import ProjectDescription

let project = Project(
    name: "Logger",
    targets: [
        .target(
            name: "Logger",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Logger",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
