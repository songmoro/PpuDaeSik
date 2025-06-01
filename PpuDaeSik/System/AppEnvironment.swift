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
        let useCases = configuredUseCases(appState: appState, repositories: repositories)
        let diContainer = DIContainer(appState: appState, useCases: useCases)
        
        return AppEnvironment(container: diContainer)
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
        let bookmarkUseCases = BookmarkUseCasesImpl(
            action: ActionBookmarkUseCaseImpl(),
            save: SaveBookmarkUseCaseImpl(bookmarkRepository: repositories.bookmarkRepository),
            load: LoadBookmarkUseCaseImpl(bookmarkRepository: repositories.bookmarkRepository)
        )
        let defaultCampusUseCases = DefaultCampusUseCasesImpl(
            save: SaveDefaultCampusUseCaseImpl(defaultCampusRepository: repositories.defaultCampusRepository),
            load: LoadDefaultCampusUseCaseImpl(defaultCampusRepository: repositories.defaultCampusRepository)
        )
        
        return .init(cafeteria: cafeteriaUseCases, bookmark: bookmarkUseCases, defaultCampus: defaultCampusUseCases)
    }
    
    private static func configuredURLSession() -> URLSession {
        return URLSession.shared
    }
}
