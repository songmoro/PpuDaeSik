//
//  DefaultCampusUseCasesTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import UseCasesImpls

final class DefaultCampusUseCasesTests: XCTestCase {
    func testLoadDefaultCampusReturnsSavedCampus() {
        let mock = DefaultCampusRepositoryMock()
        mock.campusToLoad = .양산
        let useCase = LoadDefaultCampusUseCaseImpl(defaultCampusRepository: mock)

        let result = useCase.execute()
        XCTAssertEqual(result, .양산)
    }

    func testLoadDefaultCampusReturnsDefaultWhenNil() {
        let mock = DefaultCampusRepositoryMock()
        mock.campusToLoad = nil
        let useCase = LoadDefaultCampusUseCaseImpl(defaultCampusRepository: mock)

        let result = useCase.execute()
        XCTAssertEqual(result, .부산) // fallback default
    }

    func testSaveDefaultCampusSavesCorrectly() {
        let mock = DefaultCampusRepositoryMock()
        let useCase = SaveDefaultCampusUseCaseImpl(defaultCampusRepository: mock)

        useCase.execute(defaultCampus: .밀양)
        XCTAssertEqual(mock.savedCampus, .밀양)
    }
}
