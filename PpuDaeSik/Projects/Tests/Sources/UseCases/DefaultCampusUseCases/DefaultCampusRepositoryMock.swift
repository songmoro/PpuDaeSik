//
//  DefaultCampusRepositoryMock.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

@testable import Repositories
@testable import Entities

final class DefaultCampusRepositoryMock: DefaultCampusRepository {
    var savedCampus: Campus?
    var campusToLoad: Campus?

    func saveDefaultCampus(defaultCampus: Campus) {
        savedCampus = defaultCampus
    }

    func loadDefaultCampus() -> Campus? {
        return campusToLoad
    }
}
