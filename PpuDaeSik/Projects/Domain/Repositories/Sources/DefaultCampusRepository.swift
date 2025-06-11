//
//  DefaultCampusRepository.swift
//  Repositories
//
//  Created by 송재훈 on 6/6/25.
//

import Entities

public protocol DefaultCampusRepository {
    func saveDefaultCampus(defaultCampus: Campus)
    func loadDefaultCampus() -> Campus?
}
