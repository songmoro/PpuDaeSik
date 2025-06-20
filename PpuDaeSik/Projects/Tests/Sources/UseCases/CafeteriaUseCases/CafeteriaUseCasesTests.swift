//
//  CafeteriaUseCasesTests.swift
//  Tests
//
//  Created by 송재훈 on 6/11/25.
//

import XCTest
@testable import UseCasesImpls
@testable import DTOs
@testable import Entities

final class CafeteriaUseCasesTests: XCTestCase {
    func testFetchCafeteriaMenusReturnsCorrectMenus() async {
        let mock = CafeteriaFetchRepositoryMock()
        mock.menusToReturn = [CafeteriaMenu.init(cafeteria: .학생회관학생식당, date: "2025-06-05", category: .중식, title: "일품 - 4,000원", content: "꼬지어묵우동\r\n군만두\r\n배추김치\r\n")]

        let useCase = FetchCafeteriaUseCaseImpl(cafeteriaRepository: mock)
        
        let result = try! await useCase.execute(campus: .부산)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].cafeteria, .학생회관학생식당)
    }
    
    func testFetchCafeteriaMenusThrowsError() async {
        let mock = CafeteriaFetchRepositoryMock()
        mock.errorToThrow = NotionAPIError.serviceUnavailable(description: "테스트 에러")

        let useCase = FetchCafeteriaUseCaseImpl(cafeteriaRepository: mock)

        do {
            _ = try await useCase.execute(campus: .부산)
            XCTFail("에러가 발생해야 하는데 성공함")
        } catch {
            XCTAssertTrue(error is NotionAPIError)
            XCTAssertEqual(
                (error as? NotionAPIError)?.localizedDescription,
                NotionAPIError.serviceUnavailable(description: "테스트 에러").localizedDescription
            )
        }
    }

    func testSaveCafeteriaMenusSavesCorrectly() {
        let mock = CafeteriaCacheRepositoryMock()
        let useCase = SaveCafeteriaUseCaseImpl(cafeteriaRepository: mock)

        let menus = [CafeteriaMenu.init(cafeteria: .학생회관학생식당, date: "2025-06-05", category: .중식, title: "일품 - 4,000원", content: "꼬지어묵우동\r\n군만두\r\n배추김치\r\n")]
        useCase.execute(campus: .부산, menus: menus)

        XCTAssertEqual(mock.savedMenus?.campus, .부산)
        XCTAssertEqual(mock.savedMenus?.menus, menus)
    }

    func testLoadCafeteriaMenusReturnsCorrectly() {
        let mock = CafeteriaCacheRepositoryMock()
        let expected = [CafeteriaMenu.init(cafeteria: .학생회관학생식당, date: "2025-06-05", category: .중식, title: "일품 - 4,000원", content: "꼬지어묵우동\r\n군만두\r\n배추김치\r\n")]
        mock.menusToLoad = expected

        let useCase = LoadCafeteriaUseCaseImpl(cafeteriaRepository: mock)
        let result = useCase.execute(campus: .부산)

        XCTAssertEqual(result, expected)
    }

    func testOrderCafeteriaSortsBookmarkedFirst() {
        let useCase = OrderCafeteriaUseCaseImpl()
        let bookmark: [Cafeteria] = [.진리관]
        let result = useCase.execute(campus: .부산, bookmark: bookmark)

        XCTAssertEqual(result.first, .진리관)
    }

    func testFilterCafeteriaFiltersByDateAndCampus() {
        let useCase = FilterCafeteriaUseCaseImpl()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: "2025-06-05")!

        let menus = [
            CafeteriaMenu.init(cafeteria: .학생회관학생식당, date: "2025-06-05", category: .중식, title: "일품 - 4,000원", content: "꼬지어묵우동\r\n군만두\r\n배추김치\r\n"),
            CafeteriaMenu.init(cafeteria: .비마관, date: "2025-06-04", category: .중식, title: "일품1-4,000원", content: "냉모밀국수\r\n떡갈비/머스터드\r\n백김치\r\n", time: "11:00-17:00")
        ]

        let weekComponent = WeekComponent(dayComponent: .화, date: date)
        let result = useCase.execute(menus: menus, campus: .부산, weekComponent: weekComponent)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.cafeteria, .학생회관학생식당)
    }
}
