//
//  And.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct And: ConditionOperator, CustomStringConvertible {
    let and: [any ConditionOperator]
    
    init(_ and: [any ConditionOperator]) {
        self.and = and
    }
    
    public var description: String {
        """
        {
            "and": \(and)
        }
        """
    }
}
