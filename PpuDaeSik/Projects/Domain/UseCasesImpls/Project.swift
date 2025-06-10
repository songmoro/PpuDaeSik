import ProjectDescription

let project = Project(
    name: "UseCasesImpls",
    targets: [
        .target(
            name: "UseCasesImpls",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Domain.UseCasesImpls",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
//            resources: ["Resources/**"],
            dependencies: [
                .project(target: "UseCases", path: "../UseCases", status: .required, condition: .none),
                .project(target: "Repositories", path: "../Repositories", status: .required, condition: .none)
            ]
        )
    ]
)
