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
