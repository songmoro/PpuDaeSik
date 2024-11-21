//
//  MainViewHeader.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import SwiftUI

struct MainViewHeader: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Image(viewModel.settingSheet ? "LogoEye" : "Logo")
                .resizable()
                .frame(width: UIScreen.getWidth(50), height: UIScreen.getWidth(50))
            
            Text("뿌대식")
                .font(.largeTitle())
                .foregroundColor(.black100)
            
            Spacer()
            
            Button {
                viewModel.showSettingSheet()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.largeTitle())
                    .foregroundColor(.blue100)
            }
        }
    }
}

extension MainViewHeader {
    class ViewModel: ObservableObject {
        @Published var settingSheet: Bool
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            
            self._settingSheet = .init(initialValue: appState.value.routing.mainViewRouting.settingSheet)
            
            cancelBag.collect {
                appState.map(\.routing.mainViewRouting.settingSheet)
                    .removeDuplicates()
                    .assign(to: \.settingSheet, on: self)
                
                $settingSheet
                    .removeDuplicates()
                    .sink {
                        appState[keyPath: \.value.routing.mainViewRouting.settingSheet] = $0
                    }
            }
        }
        
        func showSettingSheet() {
            settingSheet = true
        }
    }
}
