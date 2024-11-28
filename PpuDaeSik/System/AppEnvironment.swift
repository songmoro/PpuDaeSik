//
//  AppEnvironment.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import Combine
import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store(AppState())
        let session = configuredURLSession()
        let repositories = configuredRepositories(session: session)
        let services = configuredServices(appState: appState, repositories: repositories)
        let diContainer = DIContainer(appState: appState, services: services)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredServices(appState: Store<AppState>, repositories: DIContainer.Repositories) -> DIContainer.Services {
        let cafeteriaService = CafeteriaServiceImpl(appState: appState, cafeteriaRepository: repositories.cafeteriaRepository, cacheRepository: repositories.cacheRepository)
        let bookmarkService = BookmarkServiceImpl(appState: appState, bookmarkRepository: repositories.bookmarkRepository)
        let defaultCampusService = DefaultCampusServiceImpl(appState: appState, defaultCampusRepository: repositories.defaultCampusRepository)
        
        return .init(
            cafeteriaService: cafeteriaService,
            bookmarkService: bookmarkService,
            defaultCampusService: defaultCampusService
        )
    }
    
    private static func configuredRepositories(session: URLSession) -> DIContainer.Repositories {
        let cafeteriaRepository = CafeteriaRepository(session: session)
        let bookmarkRepository = BookmarkRepository(key: "bookmark")
        let defaultCampusRepository = DefaultCampusRepository(key: "defaultCampus")
        let cacheRepository = CacheRepository(key: "cachedResponse")
        
        return .init(
            cafeteriaRepository: cafeteriaRepository,
            bookmarkRepository: bookmarkRepository,
            defaultCampusRepository: defaultCampusRepository,
            cacheRepository: cacheRepository
        )
    }
    
    private static func configuredURLSession() -> URLSession {
        return URLSession.shared
    }
}
