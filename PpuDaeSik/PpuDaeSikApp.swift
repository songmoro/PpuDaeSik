//
//  PpuDaeSikApp.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

@main
struct PpuDaeSikApp: App {
//    let environment: AppEnvironment
    
    init() {
        environment = AppEnvironment.bootstrap()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(container: environment.container))
        }
    }
}
