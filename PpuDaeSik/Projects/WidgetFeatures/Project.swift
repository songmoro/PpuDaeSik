import ProjectDescription

let project = Project(
    name: "WidgetFeatures",
    targets: [
        .target(
            name: "WidgetFeatures",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.WidgetFeatures",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
