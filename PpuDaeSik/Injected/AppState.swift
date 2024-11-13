//
//  AppState.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

struct AppState {
    var routing = ViewRouting()
}

extension AppState {
    struct ViewRouting {
        var mainViewRouting = MainView.Routing()
    }
}

extension AppState {
    static var preview: AppState {
        let state = AppState()
        
        return state
    }
}
