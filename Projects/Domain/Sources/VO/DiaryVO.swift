//
//  DiaryVO.swift
//  Domain
//
//  Created by 박지윤 on 9/16/25.
//

public struct DiaryVO {
    public let diaryId: Int
    public let createdAt: String
    public let originContent: String
    public let spellingDto: SpellingVO
    public let feedback: String

    public init(diaryId: Int,
                createdAt: String,
                originContent: String,
                spellingDto: SpellingVO,
                feedback: String) {
        self.diaryId = diaryId
        self.createdAt = createdAt
        self.originContent = originContent
        self.spellingDto = spellingDto
        self.feedback = feedback
    }
}

public struct SpellingVO {
    public let revisedContent: String
    public let score: Int
    public let revisions: [RevisionVO]

    public init(revisedContent: String,
                score: Int,
                revisions: [RevisionVO]) {
        self.revisedContent = revisedContent
        self.score = score
        self.revisions = revisions
    }
}

public struct RevisionVO {
    public let originContent: String
    public let revisedContent: String
    public let beginOffset: Int
    public let comment: String
    public let category: String
    public let examples: [String]

    public init(originContent: String,
                revisedContent: String,
                beginOffset: Int,
                comment: String,
                category: String,
                examples: [String]) {
        self.originContent = originContent
        self.revisedContent = revisedContent
        self.beginOffset = beginOffset
        self.comment = comment
        self.category = category
        self.examples = examples
    }
}
