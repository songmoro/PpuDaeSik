import ProjectDescription

let project = Project(
    name: "Widget",
    targets: [
        .target(
            name: "Widget",
            destinations: [.iPhone],
            product: .appExtension,
            bundleId: "com.moro.PpuDaeSik.PpuDaeSikWidget",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
