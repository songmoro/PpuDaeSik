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
//            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Entities", path: "../../Domain/Entities", status: .required, condition: .none),
                .project(target: "Repositories", path: "../../Domain/Repositories", status: .required, condition: .none),
                .project(target: "DTOs", path: "../DTOs", status: .required, condition: .none),
                .project(target: "Mappers", path: "../Mappers", status: .required, condition: .none),
                .project(target: "Shared", path: "../../Shared", status: .required, condition: .none)
            ]
        )
    ]
)
