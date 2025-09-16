//
//  DiaryDTO.swift
//  Data
//
//  Created by 박지윤 on 9/16/25.
//

import Domain

public struct DiaryResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: DiaryDataDTO
}

public struct DiaryDataDTO: Decodable {
    public let diaryId: Int
    public let createdAt: String
    public let originContent: String
    public let spellingDto: SpellingDTO
    public let feedback: String
}

extension DiaryDataDTO {
    func toDomain() -> DiaryVO {
        let revisionVO = spellingDto.revisions.map { revision in
            RevisionVO(
                originContent: revision.originContent,
                revisedContent: revision.revisedContent,
                beginOffset: revision.beginOffset,
                comment: revision.comment,
                category: revision.category,
                examples: revision.examples
            )
        }

        let spellingVO = SpellingVO(
            revisedContent: spellingDto.revisedContent,
            score: spellingDto.score,
            revisions: revisionVO)
    
        return DiaryVO(
            diaryId: diaryId,
            createdAt: createdAt,
            originContent: originContent,
            spellingDto: spellingVO,
            feedback: feedback)
    }
}

public struct SpellingDTO: Decodable {
    public let revisedContent: String
    public let score: Int
    public let revisions: [RevisionDTO]
}

public struct RevisionDTO: Decodable {
    public let originContent: String
    public let revisedContent: String
    public let beginOffset: Int
    public let comment: String
    public let category: String
    public let examples: [String]
}
