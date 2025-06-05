import ProjectDescription

let project = Project(
    name: "UseCasesImpls",
    targets: [
        .target(
            name: "UseCasesImpls",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.UseCasesImpls",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
