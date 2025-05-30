//
//  DependencyInjector.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let services: Services
    let useCases: UseCases
    
    init(appState: Store<AppState>, services: DIContainer.Services, useCases: DIContainer.UseCases) {
        self.appState = appState
        self.services = services
        self.useCases = useCases
    }
    
    init(appState: AppState, services: DIContainer.Services, useCases: DIContainer.UseCases) {
        self.init(appState: Store(appState), services: services, useCases: useCases)
    }

    static var defaultValue: Self { Self.default }
    private static let `default` = Self(appState: AppState(), services: .stub, useCases: .stub)
}

extension DIContainer {
    struct Services {
        let bookmarkService: BookmarkService
        let defaultCampusService: DefaultCampusService
        
        init(bookmarkService: BookmarkService, defaultCampusService: DefaultCampusService) {
            self.bookmarkService = bookmarkService
            self.defaultCampusService = defaultCampusService
        }
        
        static var stub: Self {
            .init(
                bookmarkService: StubBookmarkService(),
                defaultCampusService: StubDefaultCampusService()
            )
        }
    }
}

extension DIContainer {
    struct Repositories {
        let cafeteriaRepository: CafeteriaRepository
        let bookmarkRepository: BookmarkRepository
        let defaultCampusRepository: DefaultCampusRepository
        let cacheRepositories: [Campus: CacheRepository]
    }
}

extension DIContainer {
    struct UseCases {
        let cafeteria: CafeteriaUseCases
        
        static var stub: Self {
            .init(
                cafeteria: StubCafeteriaUseCases()
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
        .init(appState: AppState.preview, services: .stub, useCases: .stub)
    }
}
