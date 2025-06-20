import ProjectDescription

let project = Project(
    name: "Logger",
    targets: [
        .target(
            name: "Logger",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.moro.PpuDaeSik.Logger",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: ["LOGGER_API_KEY":"$(LOGGER_API_KEY)"]),
            sources: ["Sources/**"],
            dependencies: [],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug", xcconfig: .relativeToCurrentFile("Configurations/Secrets.xcconfig")),
                    .release(name: "Release", xcconfig: .relativeToCurrentFile("Configurations/Secrets.xcconfig")),
                ]
            )
        )
    ]
)
