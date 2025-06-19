//
//  ReloadView.swift
//  Presentation
//
//  Created by 송재훈 on 6/19/25.
//

import SwiftUI
import Shared

struct ReloadView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack {
            SharedAsset.logoClosedSadEye.swiftUIImage
                .resizable()
                .frame(width: 50, height: 50)
            
            Text("식단을 불러오는 데 실패했습니다.")
                .padding(.bottom)
            
            Button {
                onRetry()
            } label: {
                Image(systemName: "arrow.circlepath")
                    .font(.largeTitle)
            }
        }
    }
}

#Preview {
    ReloadView {
        print()
    }
}
