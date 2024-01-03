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
                    .padding(.bottom)
                menu
                Spacer()
            }
            .onAppear {
                weekday = currentWeek()
                selectedDay = Week.allCases[Calendar.current.component(.weekday, from: Date())].rawValue
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
        HStack {
            ForEach(Campus.allCases, id: \.self) { location in
                VStack(spacing: 6) {
                    Text("\(location.rawValue)")
                        .foregroundColor(location.rawValue == selectedCampus ? .black100 : .black40)
                    
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
                    withAnimation {
                        selectedCampus = location.rawValue
                    }
                }
                .padding(.horizontal)
            }
            .font(.title())
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private var week: some View {
        HStack {
            ForEach(Week.allCases, id: \.self) { day in
                VStack(spacing: 6) {
                    Text("\(day.rawValue)")
                        .foregroundColor(.black100)
                        .font(.body())
                    
                    Group {
                        if let weekdate = weekday[day] {
                            Text("\(weekdate)")
                                .foregroundColor(day.rawValue == Week.allCases[Calendar.current.component(.weekday, from: Date())].rawValue ? .black100 : .black40)
                                .font(.headline())
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
                        withAnimation {
                            selectedDay = day.rawValue
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 2)
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
        MenuView()
    }
}

struct MenuView: View {
    @State private var isFavorite = false
    
    var body: some View {
        VStack {
            title
            card
        }
        .frame(width: UIScreen.getWidth(350))
        .padding(.horizontal)
    }
    
    private var title: some View {
        HStack {
            Text("금정회관 학생")
            
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
                .padding(.bottom, UIScreen.getHeight(6))
            
            Text("아직 식단이 없어요!")
                .font(.body())
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

#Preview {
    MainView()
}
