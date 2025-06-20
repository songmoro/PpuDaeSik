//
//  AppState.swift
//  Presentation
//
//  Created by 송재훈 on 6/8/25.
//

import Entities
import Shared

public struct AppState {
    var routing = ViewRouting()
    var tab = SelectedTab()
    var cafeteria = CafeteriaData()
    var userData = UserData()
    
    public init() { }
}

extension AppState {
    struct ViewRouting: Equatable {
        var mainViewRouting = MainView.Routing(settingSheet: false)
        
        public init() { }
    }
}

extension AppState {
    struct SelectedTab: Equatable {
        var campus: Campus = .부산
        var weekComponent: WeekComponent = .getToday()
        
        public init() { }
    }
}

extension AppState {
    struct CafeteriaData: Equatable {
        var list: [Cafeteria] = []
        var menus: Loadable<[CafeteriaMenu]> = .notRequested
        var filterByDay: [CafeteriaMenu] = []
        
        public init() { }
    }
}

extension AppState {
    struct UserData: Equatable {
        var bookmark: [Cafeteria] = []
        var defaultCampus: Campus = .부산
        
        public init() { }
    }
}

extension AppState: CustomStringConvertible {
    public var description: String {
        "AppState(\(self.routing), \(self.cafeteria), \(self.tab), \(self.userData))"
    }
}

extension AppState {
    public static var preview: AppState {
        let state = AppState()
        
        return state
    }
}
