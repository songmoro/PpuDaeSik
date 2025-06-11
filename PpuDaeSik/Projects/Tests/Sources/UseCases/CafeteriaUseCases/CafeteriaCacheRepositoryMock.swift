//
//  CafeteriaCacheRepositoryMock.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

@testable import Repositories
@testable import Entities

final class CafeteriaCacheRepositoryMock: CafeteriaCacheRepository {
    var savedMenus: (menus: [CafeteriaMenu], campus: Campus)?
    var menusToLoad: [CafeteriaMenu]? = nil

    func saveMenus(_ menus: [CafeteriaMenu], for campus: Campus) {
        savedMenus = (menus, campus)
    }

    func loadMenus(for campus: Campus) -> [CafeteriaMenu]? {
        return menusToLoad
    }
}
