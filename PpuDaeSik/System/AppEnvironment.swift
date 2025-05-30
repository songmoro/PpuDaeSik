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
        let useCases = configuredUseCases(appState: appState, repositories: repositories)
        let diContainer = DIContainer(appState: appState, services: services, useCases: useCases)
        
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredServices(appState: Store<AppState>, repositories: DIContainer.Repositories) -> DIContainer.Services {
        let bookmarkService = BookmarkServiceImpl(appState: appState, bookmarkRepository: repositories.bookmarkRepository)
        let defaultCampusService = DefaultCampusServiceImpl(appState: appState, defaultCampusRepository: repositories.defaultCampusRepository)
        
        return .init(
            bookmarkService: bookmarkService,
            defaultCampusService: defaultCampusService
        )
    }
    
    private static func configuredRepositories(session: URLSession) -> DIContainer.Repositories {
        let cafeteriaRepository = CafeteriaRepository(session: session)
        let bookmarkRepository = BookmarkRepository(key: "bookmark")
        let defaultCampusRepository = DefaultCampusRepository(key: "defaultCampus")
        let cacheRepositories = [Campus.부산: CacheRepository(key: "pusanCachedResponse"), Campus.밀양: CacheRepository(key: "milyangCachedResponse"), Campus.양산: CacheRepository(key: "yangsanCachedResponse")]
        
        return .init(
            cafeteriaRepository: cafeteriaRepository,
            bookmarkRepository: bookmarkRepository,
            defaultCampusRepository: defaultCampusRepository,
            cacheRepositories: cacheRepositories
        )
    }
    
    private static func configuredUseCases(appState: Store<AppState>, repositories: DIContainer.Repositories) -> DIContainer.UseCases {
        let cafeteriaUseCases = CafeteriaUseCasesImpl(
            cancleAll: CancleAllCafeteriaUseCaseImpl(cafeteriaRepository: repositories.cafeteriaRepository),
            fetch: FetchCafeteriaUseCaseImpl(cafeteriaRepository: repositories.cafeteriaRepository),
            checkDeployment: CheckDeploymentUseCaseImpl(cafeteriaRepository: repositories.cafeteriaRepository),
            load: LoadCafeteriaUseCaseImpl(cacheRepositories: repositories.cacheRepositories),
            save: SaveCafeteriaUseCaseImpl(cacheRepositories: repositories.cacheRepositories),
            order: OrderCafeteriaUseCaseImpl(),
            filter: FilterCafeteriaUseCaseImpl()
        )
        
        return .init(cafeteria: cafeteriaUseCases)
    }
    
    private static func configuredURLSession() -> URLSession {
        return URLSession.shared
    }
}
