import ProjectDescription

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.moro.PpuDaeSik",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Core", path: "../Core", status: .required, condition: .none),
                .project(target: "Shared", path: "../Shared", status: .required, condition: .none)
            ]
        )
    ]
)
