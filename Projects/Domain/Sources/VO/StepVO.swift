//
//  StepVO.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

public struct StepVO {
    public let stepLv: Int
    public let stepTitle: String
    public let stepDescription: String
    public let stepStatus: String
    
    public init(stepLv: Int, stepTitle: String, stepDescription: String, stepStatus: String) {
        self.stepLv = stepLv
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.stepStatus = stepStatus
    }
} 
