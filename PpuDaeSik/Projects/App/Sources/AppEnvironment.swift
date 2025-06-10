//
//  AppEnvironment.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import Combine
import Foundation
//import Entities
import RepositoriesImpls
import UseCasesImpls
import Presentation
import Shared

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
        let cafeteriaFetchRepository = CafeteriaFetchRepositoryImpl(session: session)
        let cafeteriaCacheRepository = CafeteriaCacheRepositoryImpl()
        let bookmarkRepository = BookmarkRepositoryImpl()
        let defaultCampusRepository = DefaultCampusRepositoryImpl()
        
        return .init(
            cafeteriaFetchRepository: cafeteriaFetchRepository,
            cafeteriaCacheRepository: cafeteriaCacheRepository,
            bookmarkRepository: bookmarkRepository,
            defaultCampusRepository: defaultCampusRepository
        )
    }
    
    private static func configuredUseCases(appState: Store<AppState>, repositories: DIContainer.Repositories) -> DIContainer.UseCases {
        let cafeteria = CafeteriaUseCasesImpl(
            fetch: FetchCafeteriaUseCaseImpl(cafeteriaRepository: repositories.cafeteriaFetchRepository),
            save: SaveCafeteriaUseCaseImpl(cafeteriaRepository: repositories.cafeteriaCacheRepository),
            load: LoadCafeteriaUseCaseImpl(cafeteriaRepository: repositories.cafeteriaCacheRepository),
            order: OrderCafeteriaUseCaseImpl(),
            filter: FilterCafeteriaUseCaseImpl()
        )
        let bookmark = BookmarkUseCasesImpl(
            action: ActionBookmarkUseCaseImpl(),
            save: SaveBookmarkUseCaseImpl(bookmarkRepository: repositories.bookmarkRepository),
            load: LoadBookmarkUseCaseImpl(bookmarkRepository: repositories.bookmarkRepository)
        )
        let defaultCampus = DefaultCampusUseCasesImpl(
            save: SaveDefaultCampusUseCaseImpl(defaultCampusRepository: repositories.defaultCampusRepository),
            load: LoadDefaultCampusUseCaseImpl(defaultCampusRepository: repositories.defaultCampusRepository)
        )
        
        return .init(
            cafeteria: cafeteria,
            bookmark: bookmark,
            defaultCampus: defaultCampus
        )
    }
    
    private static func configuredURLSession() -> URLSession {
        return URLSession.shared
    }
}
