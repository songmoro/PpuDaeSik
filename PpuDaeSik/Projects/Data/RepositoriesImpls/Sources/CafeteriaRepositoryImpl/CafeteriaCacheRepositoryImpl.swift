//
//  CafeteriaCacheRepositoryImpl.swift
//  RepositoriesImpls
//
//  Created by 송재훈 on 6/6/25.
//

import Foundation
import Entities
import Repositories

fileprivate extension Campus {
    var key: String {
        switch self {
        case .부산: return "pusanCachedResponse"
        case .밀양: return "milyangCachedResponse"
        case .양산: return "yangsanCachedResponse"
        }
    }
}

public struct CafeteriaCacheRepositoryImpl: CafeteriaCacheRepository {
    public init() { }
    
    public func saveMenus(_ menus: [CafeteriaMenu], for campus: Campus) {
        let encodedMenus = try? PropertyListEncoder().encode(menus)
        guard let encodedMenus = encodedMenus else { return }
        UserDefaults.standard.setValue(encodedMenus, forKey: campus.key)
    }
    
    public func loadMenus(for campus: Campus) -> [CafeteriaMenu]? {
        let cachedMenus: Data? = UserDefaults.standard.value(forKey: campus.key) as? Data
        guard let cachedMenus = cachedMenus else { return nil }
        
        let decodedMenus = try? PropertyListDecoder().decode([CafeteriaMenu].self, from: cachedMenus)
        guard let decodedMenus = decodedMenus else { return nil }
        
        return decodedMenus
    }
}
