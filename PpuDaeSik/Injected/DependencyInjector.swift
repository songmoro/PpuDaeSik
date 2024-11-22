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
    
    init(appState: Store<AppState>, services: DIContainer.Services) {
        self.appState = appState
        self.services = services
    }
    
    init(appState: AppState, services: DIContainer.Services) {
        self.init(appState: Store(appState), services: services)
    }

    static var defaultValue: Self { Self.default }
    private static let `default` = Self(appState: AppState(), services: .stub)
}

extension DIContainer {
    struct Services {
        let campusService: CampusService
        let weekdayService: WeekdayService
        let cafeteriaService: CafeteriaService
        let bookmarkService: BookmarkService
        
        init(campusService: CampusService, weekdayService: WeekdayService, cafeteriaService: CafeteriaService, bookmarkService: BookmarkService) {
            self.campusService = campusService
            self.weekdayService = weekdayService
            self.cafeteriaService = cafeteriaService
            self.bookmarkService = bookmarkService
        }
        
        static var stub: Self {
            .init(
                campusService: StubCampusService(),
                weekdayService: StubWeekdayService(),
                cafeteriaService: StubCafeteriaService(),
                bookmarkService: StubBookmarkService()
            )
        }
    }
}

extension DIContainer {
    struct Repositories {
        let notionRepository: NotionRepository
        let bookmarkRepository: BookmarkRepository
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
        .init(appState: AppState.preview, services: .stub)
    }
}
