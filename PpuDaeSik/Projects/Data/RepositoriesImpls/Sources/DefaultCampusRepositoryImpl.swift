//
//  DefaultCampusRepositoryImpl.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/22/24.
//

import Foundation
import Entities
import Repositories

//public struct DefaultCampusRepository: UserDataRepository {
//    public let key: String
//    
//    public init(key: String) {
//        self.key = key
//    }
//}

public struct DefaultCampusRepositoryImpl: DefaultCampusRepository {
    private let key: String = "defaultCampus"
    public init() {}
    
    public func saveDefaultCampus(defaultCampus: Campus) {
        UserDefaults.standard.setValue(defaultCampus.rawValue, forKey: key)
    }
    
    public func loadDefaultCampus() -> Campus? {
        let rawValue = UserDefaults.standard.value(forKey: key) as? String
        
        if let rawValue = rawValue, let defaultCampus = Campus(rawValue: rawValue) {
            return defaultCampus
        }
        else {
            return nil
        }
    }
}
