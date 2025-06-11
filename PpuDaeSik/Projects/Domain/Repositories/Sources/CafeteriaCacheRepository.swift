//
//  CafeteriaCacheRepository.swift
//  Repositories
//
//  Created by 송재훈 on 6/6/25.
//

import Entities

public protocol CafeteriaCacheRepository {
    func saveMenus(_ menus: [CafeteriaMenu], for campus: Campus)
    func loadMenus(for campus: Campus) -> [CafeteriaMenu]?
}
