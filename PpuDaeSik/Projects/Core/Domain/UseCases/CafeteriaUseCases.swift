//
//  CafeteriaUseCases.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/12/24.
//

import SwiftUI

// MARK: Provider
protocol CafeteriaUseCases {
    var cancleAll: CancleAllCafeteriaUseCase { get }
    var fetch: FetchCafeteriaUseCase { get }
    var checkDeployment: CheckDeploymentUseCase { get }
    var load: LoadCafeteriaUseCase { get }
    var save: SaveCafeteriaUseCase { get }
    var order: OrderCafeteriaUseCase { get }
    var filter: FilterCafeteriaUseCase { get }
}
//:-

// MARK: UseCase
protocol CancleAllCafeteriaUseCase {
    func execute()
}

protocol FetchCafeteriaUseCase {
    func execute(isUpdating: Bool, campus: Campus, for type: DeploymentType) async -> [CafeteriaResponse]
}

protocol CheckDeploymentUseCase {
    func execute(for type: DeploymentType) async -> Bool
}

protocol LoadCafeteriaUseCase {
    func execute(campus: Campus) -> [CafeteriaResponse]?
}

protocol SaveCafeteriaUseCase {
    func execute(campus: Campus, response: [CafeteriaResponse])
}

protocol OrderCafeteriaUseCase {
    func execute(campus: Campus, bookmark: [Cafeteria]) -> [Cafeteria]
}

protocol FilterCafeteriaUseCase {
    func execute(response: Loadable<[CafeteriaResponse]>, campus: Campus, weekComponent: WeekComponent) -> [CafeteriaResponse]
}
//:-
