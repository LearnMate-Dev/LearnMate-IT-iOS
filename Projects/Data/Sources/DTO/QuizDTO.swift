//
//  QuizDTO.swift
//  Data
//
//  Created by 박지윤 on 7/17/25.
//

import Foundation
import Domain

public struct QuizResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: QuizDataDTO
}

public struct QuizDataDTO: Decodable {
    public let stepProgressId: Int
    public let courseLv: Int
    public let stepLv: Int
    public let stepTitle: String
    public let stepDescription: String
    public let quizDto: [QuizDTO]
}

public struct QuizDTO: Decodable {
    public let quizLv: Int
    public let quizSituation: String
    public let quiz: String
    public let correctIdx: Int
    public let quizOptions: [QuizOptionDTO]
}

public struct QuizOptionDTO: Decodable {
    public let answer: String
    public let description: String
}

extension QuizDataDTO {
    func toDomain() -> QuizVO {
        let quizList = quizDto.map { quiz in
            QuizDetailVO(
                quizLv: quiz.quizLv,
                quizSituation: quiz.quizSituation,
                quiz: quiz.quiz,
                correctIdx: quiz.correctIdx,
                quizOptions: quiz.quizOptions.map { option in
                    QuizOptionVO(
                        answer: option.answer,
                        description: option.description
                    )
                }
            )
        }

        return QuizVO(
            stepProgressId: stepProgressId,
            courseLv: courseLv,
            stepLv: stepLv,
            stepTitle: stepTitle,
            stepDescription: stepDescription,
            quizList: quizList
        )
    }
}
