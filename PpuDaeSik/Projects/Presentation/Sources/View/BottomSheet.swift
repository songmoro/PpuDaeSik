//
//  BottomSheet.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/14/24.
//

import SwiftUI
import Entities
import Shared

struct BottomSheet: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 2.5)
                    .foregroundColor(.darkGray100)
                    .frame(width: UIScreen.getWidth(36), height: UIScreen.getHeight(5))
                
                HStack {
                    Text("기본 캠퍼스")
                        .foregroundColor(.black100)
                    
                    Spacer()
                    
                    Picker(selection: $viewModel.defaultCampus) {
                        ForEach(Campus.allCases, id: \.self) { campus in
                            Text(campus.rawValue)
                                .tag(campus.rawValue)
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

//#Preview {
//    Text("")
//        .sheet(isPresented: .constant(true)) {
//            BottomSheet(viewModel: .init(container: .preview))
//        }
//}
