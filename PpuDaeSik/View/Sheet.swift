//
//  Sheet.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/10/24.
//

import SwiftUI

struct Sheet: View {
    @Binding var defaultCampus: Campus
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                RectangleComponent.holdBar
                
                HStack {
                    TextComponent.sheetPickerTitle
                    
                    Spacer()
                    
                    Picker(selection: $defaultCampus) {
                        ForEach(Campus.allCases, id: \.self) { campus in
                            TextComponent.sheetPickerComponent(campus.rawValue)
                        }
                        .foregroundColor(.blue100)
                    } label: { }
                        .pickerStyle(.menu)
                    
                }
                .font(.headline())
                
                Spacer()
            }
            .padding(.top)
            .frame(width: UIScreen.getWidth(350))
            .presentationDetents([.height(UIScreen.getHeight(238))])
        }
    }
}

#Preview {
    Sheet(defaultCampus: .constant(.밀양))
}
