//
//  CafeteriaUseCasesImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 5/30/25.
//

import SwiftUI
import Entities
import UseCases
import Repositories

// MARK: Provider
public struct CafeteriaUseCasesImpl: CafeteriaUseCases {
    public let fetch: FetchCafeteriaUseCase
    public let save: SaveCafeteriaUseCase
    public let load: LoadCafeteriaUseCase
    public let order: OrderCafeteriaUseCase
    public let filter: FilterCafeteriaUseCase
    
    public init(fetch: FetchCafeteriaUseCase, save: SaveCafeteriaUseCase, load: LoadCafeteriaUseCase, order: OrderCafeteriaUseCase, filter: FilterCafeteriaUseCase) {
        self.fetch = fetch
        self.save = save
        self.load = load
        self.order = order
        self.filter = filter
    }
}
//:-

// MARK: Impl
public struct FetchCafeteriaUseCaseImpl: FetchCafeteriaUseCase {
//    private let cafeteriaRepository: CafeteriaRepositoryProtocol
    private let cafeteriaRepository: CafeteriaFetchRepository
    
    public init(cafeteriaRepository: CafeteriaFetchRepository) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    public func execute(campus: Campus) async -> [CafeteriaMenu] {
        async let menus: [CafeteriaMenu] = cafeteriaRepository.fetch(campus: campus)
        return await menus
    }
}

public struct SaveCafeteriaUseCaseImpl: SaveCafeteriaUseCase {
    private let cafeteriaRepository: CafeteriaCacheRepository
    
    public init(cafeteriaRepository: CafeteriaCacheRepository) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    public func execute(campus: Campus, menus: [CafeteriaMenu]) {
        cafeteriaRepository.saveMenus(menus, for: campus)
    }
}

public struct LoadCafeteriaUseCaseImpl: LoadCafeteriaUseCase {
    private let cafeteriaRepository: CafeteriaCacheRepository
    
    public init(cafeteriaRepository: CafeteriaCacheRepository) {
        self.cafeteriaRepository = cafeteriaRepository
    }
    
    public func execute(campus: Campus) -> [CafeteriaMenu]? {
        guard let cachedMenus: [CafeteriaMenu] = cafeteriaRepository.loadMenus(for: campus) else { return nil }
        return cachedMenus
    }
}

public struct OrderCafeteriaUseCaseImpl: OrderCafeteriaUseCase {
    public init() { }
    
    public func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria] {
        var newCafeteria: (bookmarked: [Cafeteria], unbookmarked: [Cafeteria]) = ([], [])
        
        Cafeteria.allCases.forEach {
            if campus != $0.campus { return }
            
            if bookmark.contains($0) { newCafeteria.bookmarked.append($0) }
            else { newCafeteria.unbookmarked.append($0) }
        }
        
        return newCafeteria.bookmarked + newCafeteria.unbookmarked
    }
}

public struct FilterCafeteriaUseCaseImpl: FilterCafeteriaUseCase {
    private let formatter: DateFormatter

    public init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    public func execute(menus: [CafeteriaMenu], campus: Campus, weekComponent: WeekComponent) -> [CafeteriaMenu] {
        return menus.filter { menu in
            guard let menuDate = formatter.date(from: menu.date),
                Calendar.current.component(.day, from: menuDate) == weekComponent.dayValue,
                menu.cafeteria.campus == campus
            else { return false }
            
            return true
        }
    }
}
//:-
