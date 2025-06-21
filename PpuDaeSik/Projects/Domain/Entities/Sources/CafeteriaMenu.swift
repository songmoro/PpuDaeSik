//
//  CafeteriaMenu.swift
//  Entities
//
//  Created by 송재훈 on 6/6/25.
//

import Foundation

public struct CafeteriaMenu: Hashable, Equatable, Codable {
    public var uuid = UUID()
    public let cafeteria: Cafeteria
    public let date: String
    public let category: Category
    public let title: String?
    public let content: String
    public let time: String?
    
    public init(cafeteria: Cafeteria, date: String, category: Category, title: String? = nil, content: String, time: String? = nil) {
        self.cafeteria = cafeteria
        self.date = date
        self.category = category
        self.title = title
        self.content = content
        self.time = time
    }
}

extension CafeteriaMenu {
    public func isValid(_ campus: Campus, _ date: Date = Date()) -> Bool {
        guard let menuDate = Self.dateFormatter.date(from: self.date) else { return false }
        
        return Calendar.current.isDate(menuDate, equalTo: date, toGranularity: .weekOfYear) &&
        cafeteria.campus == campus
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        return formatter
    }()
}
