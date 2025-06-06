import ProjectDescription

let project = Project(
    name: "Repositories",
    targets: [
        .target(
            name: "Repositories",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Domain.Repositories",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Entities", path: "../Entities", status: .required, condition: .none)
            ]
        )
    ]
)
