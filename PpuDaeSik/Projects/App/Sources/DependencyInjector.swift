//
//  DependencyInjector.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let useCases: UseCases
    
    init(appState: Store<AppState>, useCases: DIContainer.UseCases) {
        self.appState = appState
        self.useCases = useCases
    }
    
    init(appState: AppState, useCases: DIContainer.UseCases) {
        self.init(appState: Store(appState), useCases: useCases)
    }

    static var defaultValue: Self { Self.default }
    private static let `default` = Self(appState: AppState(), useCases: .stub)
}

extension DIContainer {
    struct Repositories {
        let cafeteriaRepository: CafeteriaRepositoryProtocol
        let bookmarkRepository: BookmarkRepository
        let defaultCampusRepository: DefaultCampusRepository
        let cacheRepositories: [Campus: CacheRepository]
    }
}

extension DIContainer {
    struct UseCases {
        let cafeteria: CafeteriaUseCases
        let bookmark: BookmarkUseCases
        let defaultCampus: DefaultCampusUseCases
        
        static var stub: Self {
            .init(
                cafeteria: StubCafeteriaUseCases(),
                bookmark: StubBookmarkUseCases(),
                defaultCampus: StubDefaultCampusUseCases()
            )
        }
    }
}

//extension EnvironmentValues {
//    var injected: DIContainer {
//        get { self[DIContainer.self] }
//        set { self[DIContainer.self] = newValue }
//    }
//}

extension DIContainer {
    static var preview: Self {
//        .init(appState: AppState.preview, services: .stub, useCases: .stub)
        .init(appState: AppState.preview, useCases: .stub)
    }
}
