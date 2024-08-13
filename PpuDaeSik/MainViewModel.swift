//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var selectedCampus = ""
    @Published var selectedDay = ""
    @Published var isSheetShow = false
    @Published var weekday: [Week: Int] = [:]
    @Published var week: [Week: DateComponents] = [:]
    @Published var defaultCampus = "부산"
    @Published var bookmark: [String] = []
    @Published var restaurant = [RestaurantResponse]()
    @Published var domitory = [DomitoryResponse]()
    
    func currentWeek() {
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let interval = calendar.interval()
        
        let week = interval.map {
            let date = calendar.date(byAdding: .day, value: $0, to: Date())

            return calendar.dateComponents([.year, .month, .day, .weekday], from: date!)
        }.compactMap({ $0 })
        
        
        self.week = Dictionary(uniqueKeysWithValues: zip(Week.allCases, week.sorted(by: { $0.weekday! < $1.weekday! })))
    }
    
    func checkDatabaseStatus() {
        RequestManager.request(.checkStatus) { status in
            status.forEach {
                if let DB = $0["DB"], let queryType = QueryType(rawValue: DB), let status = $0["Status"] {
                    self.requestByCampusDatabase(queryType, Campus(rawValue: self.selectedCampus)!, DeploymentStatus.getStatus(status))
                }
            }
        }
    }
    
    func requestByCampusDatabase(_ queryType: QueryType, _ campus: Campus, _ deploymentStatus: DeploymentStatus) {
        switch queryType {
        case .restaurant:
            RequestManager.request(.queryByCampus(.restaurant, campus, deploymentStatus), RestaurantResponse.self) {
                self.restaurant = $0
            }
        case .domitory:
            RequestManager.request(.queryByCampus(.domitory, campus, deploymentStatus), DomitoryResponse.self) {
                self.domitory = $0
            }
        }
    }
    
    func sortedByBookmark() -> [String] {
        let restaurant = Restaurant.allCases.filter {
            !bookmark.contains($0.rawValue) && ($0.campus.rawValue == selectedCampus)
        }.sorted {
            ($0.order) < ($1.order)
        }.map({ $0.rawValue })
        
        let domitory = Domitory.allCases.filter {
            !bookmark.contains($0.name) && ($0.campus.rawValue == selectedCampus)
        }.sorted {
            ($0.order) < ($1.order)
        }.map({ $0.name })
        return bookmark + restaurant + domitory
    }
    
    func filterByRestaurant(_ restaurantName: String) -> [RestaurantResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = week[selectedWeekday]?.day {
            return restaurant.filter {
                ($0.integratedRestaurant.name == restaurantName) && (Int($0.date.suffix(2)) == day)
            }.sorted {
                $0.category.order < $1.category.order
            }
        }
        
        return []
    }
    
    func filterByDomitory(_ restaurant: String) -> [DomitoryResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = week[selectedWeekday]?.day {
            return domitory.filter {
                ($0.integratedRestaurant.name == restaurant) && (Int($0.mealDate.suffix(2)) == day)
            }
        }
        
        return []
    }
    
    func checkType(_ restaurant: String) -> QueryType {
        if (Restaurant.allCases.map({ $0.rawValue }).contains(restaurant)) {
            .restaurant
        }
        else {
            .domitory
        }
    }
    
    func filterByCategory(_ category: Category, _ restaurant: [RestaurantResponse]) -> [RestaurantResponse] {
        restaurant.filter {
            $0.category == category
        }
    }
    
    func sortedRestaurant() -> [RestaurantResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = weekday[selectedWeekday] {
            let bookmarkRestaurant = restaurant.filter { restaurant in
                (bookmark.contains(restaurant.integratedRestaurant.name)) && (restaurant.integratedRestaurant.campus.rawValue == selectedCampus) && (Int(restaurant.date.suffix(2)) == day)
            }.sorted {
//                ($0.RESTAURANT.order, $0.CATEGORY.order) < ($1.RESTAURANT.order, $1.CATEGORY.order)
                $0.category.order < $1.category.order
            }
            
            let restaurant = restaurant.filter {
                (!bookmark.contains($0.integratedRestaurant.name)) && ($0.integratedRestaurant.campus.rawValue == selectedCampus) && (Int($0.date.suffix(2)) == day)
            }.sorted {
//                ($0.RESTAURANT.order, $0.CATEGORY.order) < ($1.RESTAURANT.order, $1.CATEGORY.order)
                $0.category.order < $1.category.order
            }
            
            return (bookmarkRestaurant + restaurant)
        }
        
        return []
    }
    
    func saveDefaultCampus() {
        UserDefaults.standard.setValue(defaultCampus, forKey: "defaultCampus")
    }
    
    func saveBookmark() {
        UserDefaults.standard.setValue(bookmark, forKey: "bookmark")
    }
    
    func loadDefaultCampus() {
        guard let defaultCampus = UserDefaults.standard.string(forKey: "defaultCampus") else {
            self.defaultCampus = "부산"
            selectedCampus = "부산"
            return
        }
        self.defaultCampus = defaultCampus
        selectedCampus = defaultCampus
    }
    
    func loadBookmark() {
        guard let bookmark = UserDefaults.standard.stringArray(forKey: "bookmark") else {
            self.bookmark = []
            return
        }
        self.bookmark = bookmark
    }
}
