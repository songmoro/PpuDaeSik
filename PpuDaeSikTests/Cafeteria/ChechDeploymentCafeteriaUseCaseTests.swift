//
//  ChechDeploymentCafeteriaUseCaseTests.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 6/1/25.
//

@testable import PpuDaeSik
import XCTest

final class ChechDeploymentCafeteriaUseCaseTests: XCTestCase {
    func test_배포_상태_메인_테이블_검사() async {
        // given
        let mockRestaurantResponse = NotionResponse<DeploymentProperties>(results: [Result<DeploymentProperties>(properties: DeploymentProperties(DB: Title(title: [RichText(plainText: "domitory")]), Status: Property(richText: [RichText(plainText: "Done")])))])
        let mockRestaurantDeploymentStatus = Deployment(response: mockRestaurantResponse.results.first!.properties)
        
        let mockDormitoryResponse = NotionResponse<DeploymentProperties>(results: [Result<DeploymentProperties>(properties: DeploymentProperties(DB: Title(title: [RichText(plainText: "restaurant")]), Status: Property(richText: [RichText(plainText: "Done")])))])
        let mockDormitoryDeploymentStatus = Deployment(response: mockDormitoryResponse.results.first!.properties)
        
        let MockRestaurantRepository = MockCafeteriaRepository(session: URLSession.shared, mockResponse: mockRestaurantResponse)
        let MockDormitoryRepository = MockCafeteriaRepository(session: URLSession.shared, mockResponse: mockDormitoryResponse)
        
        let restaurantUseCase = CheckDeploymentUseCaseImpl(cafeteriaRepository: MockRestaurantRepository)
        let dormitoryUseCase = CheckDeploymentUseCaseImpl(cafeteriaRepository: MockDormitoryRepository)
        
        // when
        let restaurantResult: Bool = await restaurantUseCase.execute(for: .restaurant)
        let dormitoryResult: Bool = await dormitoryUseCase.execute(for: .dormitory)
        
        // then
        XCTAssertEqual(restaurantResult, mockRestaurantDeploymentStatus.isUpdating)
        XCTAssertEqual(dormitoryResult, mockDormitoryDeploymentStatus.isUpdating)
    }
    
    func test_배포_상태_백업_테이블_검사() async {
        // given
        let mockRestaurantResponse = NotionResponse<DeploymentProperties>(results: [Result<DeploymentProperties>(properties: DeploymentProperties(DB: Title(title: [RichText(plainText: "domitory")]), Status: Property(richText: [RichText(plainText: "Update")])))])
        let mockRestaurantDeploymentStatus = Deployment(response: mockRestaurantResponse.results.first!.properties)
        
        let mockDormitoryResponse = NotionResponse<DeploymentProperties>(results: [Result<DeploymentProperties>(properties: DeploymentProperties(DB: Title(title: [RichText(plainText: "restaurant")]), Status: Property(richText: [RichText(plainText: "Update")])))])
        let mockDormitoryDeploymentStatus = Deployment(response: mockDormitoryResponse.results.first!.properties)
        
        let MockRestaurantRepository = MockCafeteriaRepository(session: URLSession.shared, mockResponse: mockRestaurantResponse)
        let MockDormitoryRepository = MockCafeteriaRepository(session: URLSession.shared, mockResponse: mockDormitoryResponse)
        
        let restaurantUseCase = CheckDeploymentUseCaseImpl(cafeteriaRepository: MockRestaurantRepository)
        let dormitoryUseCase = CheckDeploymentUseCaseImpl(cafeteriaRepository: MockDormitoryRepository)
        
        // when
        let restaurantResult: Bool = await restaurantUseCase.execute(for: .restaurant)
        let dormitoryResult: Bool = await dormitoryUseCase.execute(for: .dormitory)
        
        // then
        XCTAssertEqual(restaurantResult, mockRestaurantDeploymentStatus.isUpdating)
        XCTAssertEqual(dormitoryResult, mockDormitoryDeploymentStatus.isUpdating)
    }
}
