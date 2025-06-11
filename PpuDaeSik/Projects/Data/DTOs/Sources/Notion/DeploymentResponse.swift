//
//  DeploymentResponse.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct DeploymentResponse: NotionResponseAble {
    public typealias resultType = DeploymentProperties
    
    public var results: [Result<resultType>]
}
