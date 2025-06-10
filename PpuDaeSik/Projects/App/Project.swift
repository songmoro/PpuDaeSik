import ProjectDescription

let widgetInfoPlist: [String: Plist.Value] = [
    "CFBundleDisplayName": "$(PRODUCT_NAME)",
    "NSExtension": .dictionary([
        "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
    ])
]

let widgetSettingsDictionary: SettingsDictionary = [
    "DEVELOPMENT_TEAM": "VA3J8597P8",
    "INFOPLIST_KEY_CFBundleDisplayName": "PpuDaeSikWidget",
    "INFOPLIST_KEY_NSHumanReadableCopyright": "",
    "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
    "MARKETING_VERSION": "1.8",
    "PRODUCT_BUNDLE_IDENTIFIER": "com.moro.PpuDaeSik.PpuDaeSikWidget",
    "PRODUCT_NAME": "$(TARGET_NAME)"
]

let widgetTarget: Target = .target(
    name: "Widget",
    destinations: [.iPhone],
    product: .appExtension,
    bundleId: "com.moro.PpuDaeSik.PpuDaeSikWidget",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(with: widgetInfoPlist),
    sources: ["../App/Widget/Sources/**"],
    resources: ["../App/Widget/Resources/**"],
    dependencies: [
        .project(target: "Entities", path: "../Domain/Entities", status: .required, condition: .none),
        .project(target: "DTOs", path: "../Data/DTOs", status: .required, condition: .none),
        .project(target: "Mappers", path: "../Data/Mappers", status: .required, condition: .none),
        .project(target: "Shared", path: "../Shared", status: .required, condition: .none)
    ],
    settings: .settings(
        base: widgetSettingsDictionary,
        defaultSettings: .recommended
    )
)

let appInfoPlist: [String: Plist.Value] = [
    "CFBundleDisplayName": .string("뿌대식"),
    "UISupportedInterfaceOrientations": .array([
        .string("UIInterfaceOrientationPortrait")
    ]),
    "UILaunchScreen": .dictionary([
        "UILaunchScreen": .dictionary([:])
    ])
]

let appSettingsDictionary: SettingsDictionary = [
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
]

let appTarget: Target = .target(
    name: "App",
    destinations: [.iPhone],
    product: .app,
    bundleId: "com.moro.PpuDaeSik",
    deploymentTargets: .iOS("17.0"),
    infoPlist: .extendingDefault(with: appInfoPlist),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    dependencies: [
        .target(widgetTarget),
        .project(target: "UseCasesImpls", path: "../Domain/UseCasesImpls", status: .required, condition: .none),
        .project(target: "Presentation", path: "../Presentation", status: .required, condition: .none),
        .project(target: "RepositoriesImpls", path: "../Data/RepositoriesImpls", status: .required, condition: .none),
        .project(target: "Shared", path: "../Shared", status: .required, condition: .none)
    ],
    settings: .settings(
        base: appSettingsDictionary,
        defaultSettings: .recommended
    )
)

let project = Project(
    name: "App",
    targets: [
        appTarget,
        widgetTarget
    ]
)
