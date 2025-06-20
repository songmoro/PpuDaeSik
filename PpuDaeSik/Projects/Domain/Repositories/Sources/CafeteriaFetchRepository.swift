//
//  CafeteriaFetchRepository.swift
//  Repositories
//
//  Created by 송재훈 on 6/6/25.
//

import Entities

public protocol CafeteriaFetchRepository {
    func fetch(campus: Campus) async throws -> [CafeteriaMenu]
}
