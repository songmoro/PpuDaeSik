//
//  CafeteriaFetchRepositoryMock.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import Entities
@testable import Repositories

final class CafeteriaFetchRepositoryMock: CafeteriaFetchRepository {
    var fetchCalled = false
    var menusToReturn: [CafeteriaMenu] = []

    func fetch(campus: Campus) async -> [CafeteriaMenu] {
        fetchCalled = true
        return menusToReturn
    }
}
