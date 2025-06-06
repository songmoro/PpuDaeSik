//
//  BookmarkRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/21/24.
//

import Repositories

public struct BookmarkRepository: UserDataRepository {
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
}
