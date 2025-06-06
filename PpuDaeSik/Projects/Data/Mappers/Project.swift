import ProjectDescription

let project = Project(
    name: "Mappers",
    targets: [
        .target(
            name: "Mappers",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Data.Mappers",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "DTOs", path: "../DTOs", status: .required, condition: .none)
            ]
        )
    ]
)
