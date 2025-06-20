import ProjectDescription

let project = Project(
    name: "UseCases",
    targets: [
        .target(
            name: "UseCases",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Domain.UseCases",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Entities", path: "../Entities", status: .required, condition: .none)
            ]
        )
    ]
)
