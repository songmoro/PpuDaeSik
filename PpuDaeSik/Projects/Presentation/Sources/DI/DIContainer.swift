//
//  DIContainer.swift
//  Presentation
//
//  Created by 송재훈 on 6/8/25.
//

import SwiftUI
import UseCases
import Repositories
import Shared

public struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let useCases: UseCases
    
    public init(appState: Store<AppState>, useCases: DIContainer.UseCases) {
        self.appState = appState
        self.useCases = useCases
    }
    
    public init(appState: AppState, useCases: DIContainer.UseCases) {
        self.init(appState: Store(appState), useCases: useCases)
    }
    
    public static var defaultValue: Self { Self.default }
    private static let `default` = Self(appState: AppState(), useCases: .stub)
}

extension DIContainer {
    public struct Repositories {
        public let cafeteriaFetchRepository: CafeteriaFetchRepository
        public let cafeteriaCacheRepository: CafeteriaCacheRepository
        public let bookmarkRepository: BookmarkRepository
        public let defaultCampusRepository: DefaultCampusRepository
        
        public init(cafeteriaFetchRepository: CafeteriaFetchRepository, cafeteriaCacheRepository: CafeteriaCacheRepository, bookmarkRepository: BookmarkRepository, defaultCampusRepository: DefaultCampusRepository) {
            self.cafeteriaFetchRepository = cafeteriaFetchRepository
            self.cafeteriaCacheRepository = cafeteriaCacheRepository
            self.bookmarkRepository = bookmarkRepository
            self.defaultCampusRepository = defaultCampusRepository
        }
    }
}

extension DIContainer {
    public struct UseCases {
        public let cafeteria: CafeteriaUseCases
        public let bookmark: BookmarkUseCases
        public let defaultCampus: DefaultCampusUseCases
        
        public init(cafeteria: CafeteriaUseCases, bookmark: BookmarkUseCases, defaultCampus: DefaultCampusUseCases) {
            self.cafeteria = cafeteria
            self.bookmark = bookmark
            self.defaultCampus = defaultCampus
        }
        
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
        .init(appState: AppState.preview, useCases: .stub)
    }
}
