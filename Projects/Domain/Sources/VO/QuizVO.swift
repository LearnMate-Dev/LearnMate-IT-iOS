//
//  QuizVO.swift
//  Domain
//
//  Created by 박지윤 on 7/17/25.
//

public struct QuizVO {
    public let stepProgressId: Int
    public let courseLv: Int
    public let stepLv: Int
    public let stepTitle: String
    public let stepDescription: String
    public let quizList: [QuizDetailVO]

    public init(stepProgressId: Int, courseLv: Int, stepLv: Int, stepTitle: String, stepDescription: String, quizList: [QuizDetailVO]) {
        self.stepProgressId = stepProgressId
        self.courseLv = courseLv
        self.stepLv = stepLv
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.quizList = quizList
    }
}

public struct QuizDetailVO {
    public let quizLv: Int
    public let quizSituation: String
    public let quiz: String
    public let correctIdx: Int
    public let quizOptions: [QuizOptionVO]
    
    public init(quizLv: Int, quizSituation: String, quiz: String, correctIdx: Int, quizOptions: [QuizOptionVO]) {
        self.quizLv = quizLv
        self.quizSituation = quizSituation
        self.quiz = quiz
        self.correctIdx = correctIdx
        self.quizOptions = quizOptions
    }
}

public struct QuizOptionVO {
    public let answer: String
    public let description: String
    
    public init(answer: String, description: String) {
        self.answer = answer
        self.description = description
    }
}
