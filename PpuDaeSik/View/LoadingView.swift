//
//  LoadingView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 8/22/24.
//

import SwiftUI

struct LoadingView: View {
    @State var isAnimate: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Image("Logo")
                    .resizable()
                Image(isAnimate ? "LogoEye" : "LogoClosedEye")
                    .resizable()
            }
            .frame(width: 50, height: 50)
            .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: false), value: isAnimate)
            .onAppear {
                isAnimate = true
            }
            
            Text("식당으로 들어가고 있어요!")
            
            Spacer()
        }
    }
}
