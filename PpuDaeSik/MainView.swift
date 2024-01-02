//
//  MainView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

enum Campus: String, CaseIterable {
    case busan = "부산"
    case milyang = "밀양"
    case yangsan = "양산"
}

enum Week: String, CaseIterable {
    case sun = "일"
    case mon = "월"
    case tues = "화"
    case wednes = "수"
    case thurs = "목"
    case fri = "금"
    case satur = "토"
}

struct MainView: View {
    @State var selectedCampus = "부산"
    @State var isSheetShow = false
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                title
                campus
                Spacer()
            }
        }
    }
    
    var title: some View {
        HStack {
            Image(isSheetShow ? "LogoEye" : "Logo")
                .resizable()
                .frame(width: UIScreen.getWidth(50), height: UIScreen.getHeight(50))
            
            Text("뿌대식")
                .font(.largeTitle())
            
            Spacer()
            
            Button {
                isSheetShow = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.largeTitle())
                    .foregroundColor(.blue100)
            }
        }
        .padding(.horizontal, UIScreen.getWidth(18))
        .padding(.bottom, UIScreen.getHeight(20))
    }
    
    var campus: some View {
        HStack(spacing: 0) {
            ForEach(Campus.allCases, id: \.self) { location in
                Button {
                    selectedCampus = location.rawValue
                } label: {
                    Text("\(location.rawValue)")
                        .foregroundColor(location.rawValue == selectedCampus ? .black100 : .black40)
                        .padding(.bottom, UIScreen.getHeight(6))
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .foregroundColor(location.rawValue == selectedCampus ? .blue100 : .clear)
                                .frame(height: UIScreen.getHeight(3))
                        }
                }
                .padding(.trailing, UIScreen.getWidth(18))
            }
            .font(.title())
            
            Spacer()
        }
        .padding(.horizontal, UIScreen.getWidth(18))
    }
}

#Preview {
    MainView()
}
