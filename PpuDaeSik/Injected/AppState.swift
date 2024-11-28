//
//  AppState.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

struct AppState {
    var routing = ViewRouting()
    var tab = SelectedTab()
    var cafeteria = CafeteriaData()
    var userData = UserData()
}

extension AppState {
    struct ViewRouting: Equatable {
        var mainViewRouting = MainView.Routing()
    }
}

extension AppState {
    struct SelectedTab: Equatable {
        var campus: Campus = .부산
        var weekComponent: WeekComponent? = .today
    }
}

extension AppState {
    struct CafeteriaData: Equatable {
        var list: [Cafeteria] = []
        var response: [CafeteriaResponse] = []
        var filterByDay: [CafeteriaResponse] = []
    }
}

extension AppState {
    struct UserData: Equatable {
        var bookmark: [Cafeteria] = []
        var defaultCampus: Campus = .부산
    }
}

extension AppState {
    static var preview: AppState {
        let state = AppState()
        
        return state
    }
}
