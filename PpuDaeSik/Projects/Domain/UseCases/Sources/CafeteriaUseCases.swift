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
//    var cancleAll: CancleAllCafeteriaUseCase { get }
    var fetch: FetchCafeteriaUseCase { get }
//    var checkDeployment: CheckDeploymentUseCase { get }
    var save: SaveCafeteriaUseCase { get }
    var load: LoadCafeteriaUseCase { get }
    var order: OrderCafeteriaUseCase { get }
    var filter: FilterCafeteriaUseCase { get }
}
//:-

// MARK: UseCase
//public protocol CancleAllCafeteriaUseCase {
//    func execute()
//}

public protocol FetchCafeteriaUseCase {
//    func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse]
    func execute(campus: Campus) async -> [CafeteriaMenu]
}

//public protocol CheckDeploymentUseCase {
//    func execute(for type: DeploymentType) async -> Bool
//}

public protocol SaveCafeteriaUseCase {
//    func execute(campus: Campus, response: [CafeteriaResponse])
    func execute(campus: Campus, menus: [CafeteriaMenu])
}

public protocol LoadCafeteriaUseCase {
//    func execute(campus: Campus) -> [CafeteriaResponse]?
    func execute(campus: Campus) -> [CafeteriaMenu]?
}

public protocol OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria]
}

public protocol FilterCafeteriaUseCase {
//    func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse]
    func execute(menus: [CafeteriaMenu], campus: Campus, weekComponent: WeekComponent) -> [CafeteriaMenu]
}
//:-
