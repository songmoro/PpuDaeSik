//
//  MainViewHeader.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import SwiftUI
import Shared

struct MainViewHeader: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
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

