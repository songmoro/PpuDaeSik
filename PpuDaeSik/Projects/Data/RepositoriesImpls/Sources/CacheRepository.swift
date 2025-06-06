//
//  CacheRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/28/24.
//

import Repositories

public struct CacheRepository: UserDataRepository {
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
}
