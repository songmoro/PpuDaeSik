//
//  CafeteriaHeader.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/17/24.
//

import SwiftUI

/// 식당 이름과 북마크를 설정할 수 있는 뷰
struct CafeteriaHeader: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.cafeteria.name)
                .font(.headline())
                .foregroundColor(.black100)
            
            Spacer()
            
            Button {
                viewModel.bookmarkAction()
            } label: {
                Image(systemName: "star.fill")
                    .font(.headline())
                    .foregroundColor(viewModel.isBookmarked() ? .yellow100 : .black20)
            }
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
}

extension CafeteriaHeader {
    class ViewModel: ObservableObject {
        let cafeteria: Cafeteria
        let container: DIContainer
        
        init(container: DIContainer, cafeteria: Cafeteria) {
            self.container = container
            self.cafeteria = cafeteria
        }
        
        // MARK: functions
        func isBookmarked() -> Bool {
            let appState = container.appState
            let bookmark = appState[\.userData.bookmark]
            
            return bookmark.contains(cafeteria)
        }
        
        func bookmarkAction() {
            let appState = container.appState
            let bookmarkUseCases = container.useCases.bookmark
            let bookmark = appState[\.userData.bookmark]
            
            let newBookmark = bookmarkUseCases.action.execute(bookmark: bookmark, cafeteria: cafeteria)
            bookmarkUseCases.save.execute(bookmark: newBookmark)
            let loadedBookmark = bookmarkUseCases.load.execute()
            appState[\.userData.bookmark] = loadedBookmark
        }
    }
}
