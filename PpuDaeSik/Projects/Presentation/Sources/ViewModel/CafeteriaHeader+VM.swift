//
//  CafeteriaHeaderViewModel.swift
//  Presentation
//
//  Created by 송재훈 on 6/6/25.
//

import SwiftUI
import Entities
import Shared

extension CafeteriaHeader {
    class ViewModel: ObservableObject {
        let cafeteria: Cafeteria
        let container: DIContainer
        let appState: Store<AppState>
        let useCases: DIContainer.UseCases
        
        init(container: DIContainer, cafeteria: Cafeteria) {
            self.container = container
            self.appState = container.appState
            self.useCases = container.useCases
            self.cafeteria = cafeteria
        }
        
        // MARK: functions
        func isBookmarked() -> Bool {
            let bookmark = appState[\.userData.bookmark]
            
            return bookmark.contains(cafeteria)
        }
        
        func bookmarkAction() {
            let bookmark = appState[\.userData.bookmark]
            
            let newBookmark = useCases.bookmark.action.execute(bookmark: bookmark, cafeteria: cafeteria)
            useCases.bookmark.save.execute(bookmark: newBookmark)
            let loadedBookmark = useCases.bookmark.load.execute()
            appState[\.userData.bookmark] = loadedBookmark
        }
    }
}
