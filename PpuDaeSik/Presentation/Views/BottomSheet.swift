//
//  BottomSheet.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/14/24.
//

import SwiftUI

struct BottomSheet: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 2.5)
                    .foregroundColor(.darkGray100)
                    .frame(width: UIScreen.getWidth(36), height: UIScreen.getHeight(5))
                
                HStack {
                    TextComponent.sheetPickerTitle
                    Spacer()
                    
                    Picker(selection: $viewModel.defaultCampus) {
                        ForEach(Campus.allCases, id: \.self) { campus in
                            TextComponent.sheetPickerComponent(campus.rawValue)
                        }
                    } label: { }
                        .foregroundColor(.blue100)
                        .pickerStyle(.menu)
                }
                
                Spacer()
            }
            .font(.headline())
            .frame(width: UIScreen.getWidth(350))
            .presentationDetents([.height(UIScreen.getHeight(238))])
            .padding(.top)
        }
    }
}

extension BottomSheet {
    class ViewModel: ObservableObject {
        @Published var defaultCampus: Campus
        
        let container: DIContainer
        let cancelBag = CancelBag()
        
        init(container: DIContainer) {
            self.container = container
            let appState = container.appState
            
            _defaultCampus = .init(initialValue: appState.value.userData.defaultCampus)
            
            cancelBag.collect {
                $defaultCampus.sink {
                    appState[\.userData.defaultCampus] = $0
                }
            }
        }
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            BottomSheet(viewModel: .init(container: .preview))
        }
}
