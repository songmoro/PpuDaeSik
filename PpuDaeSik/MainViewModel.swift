//
//  MainViewModel.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 1/4/24.
//

import SwiftUI
import Moya

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
        let dateFormatter = DateFormatter(format: "yyyy-MM-dd HH:mm:ss")
        
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ko_KR")
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            
            return calendar
        }()
        
        let interval: [Int] = switch calendar.component(.weekday, from: Date()) {
        case 1: [ 0,  1,  2,  3,  4,  5,  6]
        case 2: [-1,  0,  1,  2,  3,  4,  5]
        case 3: [-2, -1,  0,  1,  2,  3,  4]
        case 4: [-3, -2, -1,  0,  1,  2,  3]
        case 5: [-4, -3, -2, -1,  0,  1,  2]
        case 6: [-5, -4, -3, -2, -1,  0,  1]
        case 7: [-6, -5, -4, -3, -2, -1,  0]
        default: []
        }
        
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
            !bookmark.contains($0.rawValue) && ($0.campus().rawValue == selectedCampus)
        }.sorted {
            ($0.order()) < ($1.order())
        }.map({ $0.rawValue })
        
        let domitory = Domitory.allCases.filter {
            !bookmark.contains($0.name()) && ($0.campus().rawValue == selectedCampus)
        }.sorted {
            ($0.order()) < ($1.order())
        }.map({ $0.name() })
        return bookmark + restaurant + domitory
    }
    
    func filterByRestaurant(_ restaurantName: String) -> [RestaurantResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = week[selectedWeekday]?.day {
            return restaurant.filter {
                ($0.RESTAURANT.rawValue == restaurantName) && (Int($0.MENU_DATE.suffix(2)) == day)
            }.sorted {
                $0.CATEGORY.order() < $1.CATEGORY.order()
            }
        }
        
        return []
    }
    
    func filterByDomitory(_ restaurant: String) -> [DomitoryResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = week[selectedWeekday]?.day {
            return domitory.filter {
                ($0.domitory.name() == restaurant) && (Int($0.mealDate.suffix(2)) == day)
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
            $0.CATEGORY == category
        }
    }
    
    func sortedRestaurant() -> [RestaurantResponse] {
        if let selectedWeekday = Week(rawValue: selectedDay), let day = weekday[selectedWeekday] {
            let bookmarkRestaurant = restaurant.filter { restaurant in
                (bookmark.contains(restaurant.NAME)) && (restaurant.CAMPUS.rawValue == selectedCampus) && (Int(restaurant.MENU_DATE.suffix(2)) == day)
            }.sorted {
                ($0.RESTAURANT.order(), $0.CATEGORY.order()) < ($1.RESTAURANT.order(), $1.CATEGORY.order())
            }
            
            let restaurant = restaurant.filter {
                (!bookmark.contains($0.NAME)) && ($0.CAMPUS.rawValue == selectedCampus) && (Int($0.MENU_DATE.suffix(2)) == day)
            }.sorted {
                ($0.RESTAURANT.order(), $0.CATEGORY.order()) < ($1.RESTAURANT.order(), $1.CATEGORY.order())
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
