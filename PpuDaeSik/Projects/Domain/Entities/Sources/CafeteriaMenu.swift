//
//  CafeteriaMenu.swift
//  Entities
//
//  Created by 송재훈 on 6/6/25.
//

public struct CafeteriaMenu: Equatable {
    public let cafeteria: Cafeteria
    public let date: String
    public let category: Category
    public let meals: Meals
    
    public struct Meals: Equatable {
        public let breakfast: Meal?
        public let lunch: Meal?
        public let dinner: Meal?
        
        public struct Meal: Equatable {
            public let title: String?
            public let content: String
            public let time: String?
        }
    }
}
