import ProjectDescription

let project = Project(
    name: "RepositoriesImpls",
    targets: [
        .target(
            name: "RepositoriesImpls",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Data.RepositoriesImpls",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Repositories", path: "../../Domain/Repositories", status: .required, condition: .none)
            ]
        )
    ]
)
