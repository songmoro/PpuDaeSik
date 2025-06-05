//
//  DefaultCampusRepository.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/22/24.
//

public struct DefaultCampusRepository: UserDataRepository {
    public let key: String
    
    public init(key: String) {
        self.key = key
    }
}
