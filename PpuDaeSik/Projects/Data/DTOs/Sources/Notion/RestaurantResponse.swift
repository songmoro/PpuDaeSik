//
//  RestaurantResponse.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct RestaurantResponse: NotionResponseAble {
    public typealias resultType = RestaurantProperties
    
    public var results: [Result<resultType>]
}
