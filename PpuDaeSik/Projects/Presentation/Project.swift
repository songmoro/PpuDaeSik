import ProjectDescription

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Presentation",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Entities", path: "../Domain/Entities", status: .required, condition: .none),
                .project(target: "UseCases", path: "../Domain/UseCases", status: .required, condition: .none),
                .project(target: "Shared", path: "../Shared", status: .required, condition: .none)
            ]
        )
    ]
)
