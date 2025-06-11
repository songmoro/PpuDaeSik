//
//  DormitoryResponse.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct DormitoryResponse: NotionResponseAble {
    public typealias resultType = DomitoryProperties
    
    public var results: [Result<resultType>]
}
