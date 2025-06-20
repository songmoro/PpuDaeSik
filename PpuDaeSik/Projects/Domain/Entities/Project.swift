import ProjectDescription

let project = Project(
    name: "Entities",
    targets: [
        .target(
            name: "Entities",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Domain.Entities",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)
