//
//  CafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI
import Entities

// MARK: Provider
public protocol CafeteriaUseCases {
    var fetch: FetchCafeteriaUseCase { get }
    var save: SaveCafeteriaUseCase { get }
    var load: LoadCafeteriaUseCase { get }
    var order: OrderCafeteriaUseCase { get }
    var filter: FilterCafeteriaUseCase { get }
}
//:-

// MARK: UseCase
public protocol FetchCafeteriaUseCase {
    func execute(campus: Campus) async throws -> [CafeteriaMenu]
}

public protocol SaveCafeteriaUseCase {
    func execute(campus: Campus, menus: [CafeteriaMenu])
}

public protocol LoadCafeteriaUseCase {
    func execute(campus: Campus) -> [CafeteriaMenu]?
}

public protocol OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria]
}

public protocol FilterCafeteriaUseCase {
    func execute(menus: [CafeteriaMenu], campus: Campus, weekComponent: WeekComponent) -> [CafeteriaMenu]
}
//:-
