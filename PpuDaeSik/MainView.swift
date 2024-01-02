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
    @State private var selectedCampus = "부산"
    @State private var selectedDay = "일"
    @State private var isSheetShow = false
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                title
                campus
                week
                Divider()
                Spacer()
            }
        }
    }
    
    private var title: some View {
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
        .padding(.horizontal, UIScreen.getWidth(12))
        .padding(.bottom, UIScreen.getHeight(12))
    }
    
    private var campus: some View {
        HStack(spacing: 0) {
            ForEach(Campus.allCases, id: \.self) { location in
                Button {
                    selectedCampus = location.rawValue
                } label: {
                    VStack(spacing: 8) {
                        Text("\(location.rawValue)")
                            .foregroundColor(location.rawValue == selectedCampus ? .black100 : .black40)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: UIScreen.getHeight(5))
                            .overlay {
                                Circle()
                                    .foregroundColor(location.rawValue == selectedCampus ? .blue100 : .clear)
                            }
                    }
                }
            }
            .font(.title())
        }
        .padding(.horizontal, UIScreen.getWidth(12))
        .padding(.bottom, UIScreen.getHeight(12))
    }
    
    private var week: some View {
        HStack(spacing: 0) {
            ForEach(Week.allCases, id: \.self) { day in
                VStack(spacing: 8) {
                    Text("\(day.rawValue)")
                        .foregroundColor(.black100)
                        .font(.body())
                    
                    Button {
                        selectedDay = day.rawValue
                    } label: {
                        VStack(spacing: 8) {
                            Text("20")
                                .foregroundColor(day.rawValue == selectedDay ? .black100 : .black40)
                                .font(.headline())
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: UIScreen.getHeight(5))
                                .overlay {
                                    Circle()
                                        .foregroundColor(day.rawValue == selectedDay ? .blue100 : .clear)
                                }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, UIScreen.getWidth(12))
    }
}

#Preview {
    MainView()
}
