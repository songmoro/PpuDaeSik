import ProjectDescription

//let infoPlist: [String: Plist.Value] = [
//    "NSExtension": .dictionary([
//        "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
//    ])
//]
//
//let project = Project(
//    name: "Widget",
//    targets: [
//        .target(
//            name: "Widget",
//            destinations: [.iPhone],
//            product: .appExtension,
//            bundleId: "com.moro.PpuDaeSik.PpuDaeSikWidget",
//            deploymentTargets: .iOS("17.0"),
//            infoPlist: .extendingDefault(with: infoPlist),
//            sources: ["Sources/**"],
//            resources: ["Resources/**"],
//            dependencies: [
//                .project(target: "Entities", path: "../Domain/Entities", status: .required, condition: .none),
//                .project(target: "DTOs", path: "../Data/DTOs", status: .required, condition: .none),
//                .project(target: "Shared", path: "../Shared", status: .required, condition: .none)
//            ]
//        )
//    ]
//)
