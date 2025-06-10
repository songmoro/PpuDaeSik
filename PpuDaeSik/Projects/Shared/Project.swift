import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "UIAppFonts": .array([
        .string("Pretendard-Regular.otf")
    ])
]

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "Shared",
            destinations: [.iPhone],
            product: .staticFramework,
            bundleId: "com.moro.PpuDaeSik.Shared",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
