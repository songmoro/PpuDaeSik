//
//  Deployment.swift
//  PpuDaeSik
//
//  Created by 송재훈 on 11/24/24.
//

struct Deployment {
    let database: DeploymentType
    let isUpdating: Bool
    
    init(response: DeploymentProperties) {
        self.database = response.DB.title[0].plainText == "restaurant" ? .restaurant : .dormitory
        self.isUpdating = response.Status.richText[0].plainText != "Done"
    }
}
