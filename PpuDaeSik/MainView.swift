//
//  MainView.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/2/24.
//

import SwiftUI

enum Campus: String, CaseIterable {
    case 부산, 밀양, 양산
    
    var restaurant: [String] {
        switch self {
        case .부산:
            ["금정회관 학생", "금정회관 교직원", "샛벌회관", "학생회관 학생", "진리관", "웅비관", "자유관"]
        case .밀양:
            ["학생회관 학생", "학생회관 교직원", "비마관"]
        case .양산:
            ["편의동", "행림관"]
        }
    }
}

enum Week: String, CaseIterable {
    case 일, 월, 화, 수, 목, 금, 토
}

struct Menu {
    var restaurant: String
    var menuBycategory: [String: [String]] = ["조식": [], "중식": [], "석식": []]
}

struct MainView: View {
    @Namespace private var namespcae
    @State private var selectedCampus = "부산"
    @State private var selectedDay = ""
    @State private var isSheetShow = false
    @State private var weekday: [Week: Int] = [:]
    
    var body: some View {
        ZStack {
            Color.gray100.ignoresSafeArea()
            
            VStack {
                title
                campus
                week
                Divider()
                menu
                Spacer()
            }
            .frame(width: UIScreen.getWidth(350))
            .onAppear {
                weekday = currentWeek()
                selectedDay = Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue
            }
        }
    }
    
    private var title: some View {
        HStack {
            Image(isSheetShow ? "LogoEye" : "Logo")
                .resizable()
                .frame(width: UIScreen.getWidth(50), height: UIScreen.getWidth(50))
            
            Text("뿌대식")
                .font(.largeTitle())
                .foregroundColor(.black100)
            
            Spacer()
            
            Button {
                isSheetShow = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.largeTitle())
                    .foregroundColor(.blue100)
            }
        }
    }
    
    private var campus: some View {
        HStack(spacing: 0) {
            ForEach(Campus.allCases, id: \.self) { location in
                VStack(spacing: 0) {
                    Text("\(location.rawValue)")
                        .foregroundColor(location.rawValue == selectedCampus ? .black100 : .black40)
                        .padding(.bottom, UIScreen.getHeight(6))
                    
                    if location.rawValue == selectedCampus {
                        Circle()
                            .foregroundColor(.blue100)
                            .frame(height: UIScreen.getHeight(5))
                            .matchedGeometryEffect(id: "campus", in: namespcae)
                    }
                    else {
                        Circle()
                            .foregroundColor(.clear)
                            .frame(height: UIScreen.getHeight(5))
                    }
                }
                .onTapGesture {
                    selectedCampus = location.rawValue
                }
                .animation(.default, value: selectedCampus)
                .padding(.trailing)
            }
            .font(.title())
            
            Spacer()
        }
        .padding(.bottom, UIScreen.getHeight(8))
    }
    
    private var week: some View {
        HStack(spacing: 0) {
            ForEach(Week.allCases, id: \.self) { day in
                VStack(spacing: 0) {
                    Text("\(day.rawValue)")
                        .foregroundColor(.black100)
                        .font(.body())
                    
                    Group {
                        if let weekdate = weekday[day] {
                            Text("\(weekdate)")
                                .foregroundColor(day.rawValue == Week.allCases[Calendar.current.component(.weekday, from: Date()) - 1].rawValue ? .black100 : .black40)
                                .font(.headline())
                                .padding(.bottom, UIScreen.getHeight(6))
                        }
                        
                        if day.rawValue == selectedDay  {
                            Circle()
                                .foregroundColor(.blue100)
                                .frame(height: UIScreen.getHeight(5))
                                .matchedGeometryEffect(id: "weekday", in: namespcae)
                        }
                        else {
                            Circle()
                                .foregroundColor(.clear)
                                .frame(height: UIScreen.getHeight(5))
                        }
                    }
                    .onTapGesture {
                        selectedDay = day.rawValue
                    }
                    .animation(.default, value: selectedDay)
                }
                .padding(.trailing)
            }
            .frame(width: UIScreen.getWidth(350 / 7))
        }
        .padding(.bottom, UIScreen.getHeight(2))
    }
    
    private func currentWeek() -> [Week: Int] {
        var week: [Week: Int] = [:]
        let current = Calendar.current
        
        if let weekend = current.nextWeekend(startingAfter: Date())?.end {
            for (weekday, interval) in zip(Week.allCases, (-8)...(-2)) {
                if let intervalDate = current.date(byAdding: .day, value: interval, to: weekend), let day = current.dateComponents([.day], from: intervalDate).day {
                    week[weekday] = day
                }
            }
        }
        
        return week
    }
    
    private var menu: some View {
        ScrollView {
            if let restaurantByCampus = Campus(rawValue: selectedCampus)?.restaurant {
                ForEach(restaurantByCampus, id: \.self) { restaurant in
                    MenuView(restaurant: restaurant)
                }
            }
        }
    }
    
    private struct MenuView: View {
        @State private var isFavorite = false
        let restaurant: String
        
        var body: some View {
            VStack {
                title
                card
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        
        private var title: some View {
            HStack {
                Text(restaurant)
                    .font(.headline())
                    .foregroundColor(.black100)
                
                Spacer()
                
                Button {
                    isFavorite = true
                } label: {
                    Image(systemName: "star.fill")
                        .font(.headline())
                        .foregroundColor(isFavorite ? .yellow100 : .black20)
                }
            }
        }
        
        private var card: some View {
            VStack(alignment: .leading) {
                Text("중식")
                    .font(.subhead())
                    .foregroundColor(.black100)
                    .padding(.bottom, UIScreen.getHeight(6))
                
                Text("아직 식단이 없어요!")
                    .font(.body())
                    .foregroundColor(.black100)
            }
            .padding()
            .frame(width: UIScreen.getWidth(350), alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white100)
                    .shadow(radius: 2)
            }
        }
    }
}

#Preview {
    MainView()
}
