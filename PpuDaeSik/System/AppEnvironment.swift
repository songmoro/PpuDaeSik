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
        let defaultCampusService = DefaultCampusServiceImpl(appState: appState, defaultCampusRepository: repositories.defaultCampusRepository)
        
        return .init(
            campusService: campusService,
            weekdayService: weekdayService,
            cafeteriaService: cafeteriaService,
            bookmarkService: bookmarkService,
            defaultCampusService: defaultCampusService
        )
    }

    private static func configuredRepositories(session: URLSession) -> DIContainer.Repositories {
        let notionRepository = NotionRepositoryImpl()
        let bookmarkRepository = BookmarkRepository(key: "bookmark")
        let defaultCampusRepository = DefaultCampusRepository(key: "defaultCampus")
        
        return .init(notionRepository: notionRepository, bookmarkRepository: bookmarkRepository, defaultCampusRepository: defaultCampusRepository)
    }

    private static func configuredURLSession() -> URLSession {
        return URLSession.shared
    }
}
