//
//  PpuDaeSikApp.swift
//  Manifests
//
//  Created by 송재훈 on 6/2/25.
//

import SwiftUI
import Presentation
import Combine

@main
struct PpuDaeSikApp: App {
    let environment: AppEnvironment
    
    init() {
        environment = AppEnvironment.bootstrap()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: .init(container: environment.container))
        }
    }
}
