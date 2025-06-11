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
            dependencies: [
//                .project(target: "Entities", path: "../Domain/Entities", status: .required, condition: .none),
//                .project(target: "UseCasesImpls", path: "../Domain/UseCasesImpls", status: .required, condition: .none),
//                .project(target: "Repositories", path: "../Domain/Repositories", status: .required, condition: .none),
//                .project(target: "DTOs", path: "../Data/DTOs", status: .required, condition: .none),
//                .project(target: "Mappers", path: "../Data/Mappers", status: .required, condition: .none)
            ]
        )
    ]
)
