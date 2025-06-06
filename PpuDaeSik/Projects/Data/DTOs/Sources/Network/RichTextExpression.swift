//
//  RichTextExpression.swift
//  DTOs
//
//  Created by 송재훈 on 6/6/25.
//

public struct RichTextExpression: ConditionOperator, CustomStringConvertible {
    let property: String
    let rich_text: RichText
    
    init(property: String, rich_text: String) {
        self.property = property
        self.rich_text = .init(equals: rich_text)
    }
    
    struct RichText: Codable {
        let equals: String
    }
    
    public var description: String {
        """
        {
            "property": "\(property)",
            "rich_text": {
                "equals": "\(rich_text.equals)"
            }
        }
        """
    }
}
