import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "UISupportedInterfaceOrientations": .array([
        .string("UIInterfaceOrientationPortrait")
    ]),
    "UILaunchScreen": .dictionary([
        "UILaunchScreen": .dictionary([:])
    ])  
//    "UIAppFonts": .array([
//        .string("Pretendard-Regular.otf")
//    ])
//    "Bundle name": "$(PRODUCT_NAME)",
//    "Bundle identifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
//    "InfoDictionary version": "6.0",
//    "App Category": "Food & Drink",
//    "Bundle version": "$(CURRENT_PROJECT_VERSION)",
//    "Application supports indirect input events": .boolean(true),
//    "Executable file": "$(EXECUTABLE_NAME)",
//    "Application requires iPhone environment": .boolean(true),
//    "Application Scene Manifest": .dictionary([
//        "Enable Multiple Windows": .boolean(true),
//        "Scene Configuration": .dictionary([:])
//    ]),
//    "Supported interface orientations": .array(["Portrait (bottom home button)"]),
//    "Bundle display name": .string("뿌대식"),
//    "Fonts provided by application": "Pretendard-Regular.otf",
//    "Bundle OS Type code": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
//    "Launch Screen": .dictionary(["UILaunchScreen": .dictionary([:])]),
//    "Default localization": "$(DEVELOPMENT_LANGUAGE)",
//    "Bundle version string (short)": "$(MARKETING_VERSION)"
]

let project = Project(
    name: "App",
    targets: [
        .target(
            name: "App",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.moro.PpuDaeSik",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "UseCasesImpls", path: "../Domain/UseCasesImpls", status: .required, condition: .none),
                .project(target: "Presentation", path: "../Presentation", status: .required, condition: .none),
                .project(target: "RepositoriesImpls", path: "../Data/RepositoriesImpls", status: .required, condition: .none),
                .project(target: "Shared", path: "../Shared", status: .required, condition: .none)
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS": "NO",
                    "CODE_SIGN_STYLE": "Automatic",
                    "CURRENT_PROJECT_VERSION": "1",
                    "DEVELOPMENT_TEAM": "VA3J8597P8",
                    "ENABLE_PREVIEWS": "YES",
                    "INFOPLIST_KEY_CFBundleDisplayName": "뿌대식",
                    "INFOPLIST_KEY_LSApplicationCategoryType": "public.app-category.food-and-drink",
                    "INFOPLIST_KEY_UIApplicationSceneManifest_Generation": "YES",
                    "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
                    "INFOPLIST_KEY_UILaunchScreen_Generation": "YES",
                    "INFOPLIST_KEY_UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait",
                    "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
                    "MARKETING_VERSION": "1.8",
                    "PRODUCT_BUNDLE_IDENTIFIER": "com.moro.PpuDaeSik",
                    "SUPPORTED_PLATFORMS": "iphoneos iphonesimulator",
                    "SUPPORTS_MACCATALYST": "NO",
                    "SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD": "NO",
                    "SWIFT_EMIT_LOC_STRINGS": "YES",
                    "SWIFT_VERSION": "5.0",
                    "TARGETED_DEVICE_FAMILY": "1"
                ],
                defaultSettings: .recommended
            )
        )
    ]
)
