//
//  Deployment.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct Deployment {
    public let database: DeploymentType
    public let isUpdating: Bool
    
    public init(database: DeploymentType, isUpdating: Bool) {
        self.database = database
        self.isUpdating = isUpdating
    }
}
