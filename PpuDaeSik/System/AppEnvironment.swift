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
        let cancelBag = CancelBag()

        return AppEnvironment(container: diContainer)
    }

    private static func configuredServices(appState: Store<AppState>, repositories: DIContainer.Repositories) -> DIContainer.Services {
        let campusService = CampusServiceImpl()
        let weekdayService = WeekdayServiceImpl()
        let cafeteriaService = CafeteriaServiceImpl()
        let bookmarkService = BookmarkServiceImpl(appState: appState, bookmarkRepository: repositories.bookmarkRepository)
        
        return .init(
            campusService: campusService,
            weekdayService: weekdayService,
            cafeteriaService: cafeteriaService,
            bookmarkService: bookmarkService
        )
    }

    private static func configuredRepositories(session: URLSession) -> DIContainer.Repositories {
        let notionRepository = NotionRepositoryImpl()
        let bookmarkRepository = BookmarkRepository(key: "bookmark")
        
        return .init(notionRepository: notionRepository, bookmarkRepository: bookmarkRepository)
    }

    private static func configuredURLSession() -> URLSession {
        return URLSession.shared
    }
}
