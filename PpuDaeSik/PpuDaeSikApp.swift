//
//  PpuDaeSikApp.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

@main
struct PpuDaeSikApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
