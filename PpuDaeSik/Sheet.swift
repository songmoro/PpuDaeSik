//
//  Sheet.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/10/24.
//

import SwiftUI

struct Sheet: View {
    @Binding var defaultCampus: String
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 2.5)
                .foregroundColor(.darkGray100)
                .frame(width: UIScreen.getWidth(36), height: UIScreen.getHeight(5))
            
            HStack {
                Text("기본 캠퍼스")
                    .foregroundColor(.black100)
                
                Spacer()
                
                Picker(selection: $defaultCampus) {
                    ForEach(Campus.allCases, id: \.self) {
                        Text($0.rawValue)
                            .tag($0.rawValue)
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

#Preview {
    Sheet(defaultCampus: .constant("밀양"))
}
