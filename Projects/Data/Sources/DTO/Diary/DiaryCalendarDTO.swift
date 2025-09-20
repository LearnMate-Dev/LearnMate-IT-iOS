//
//  DiaryCalendarDTO.swift
//  Data
//
//  Created by 박지윤 on 9/16/25.
//

import Domain

public struct DiaryCalendarResponseDTO: Decodable {
    public let is_success: Bool
    public let code: String
    public let message: String
    public let data: DiaryCalendarDataDTO
}

public struct DiaryCalendarDataDTO: Decodable {
    public let year: Int
    public let month: Int
    public let diaryList: [DiaryListDTO]
}
public struct DiaryListDTO: Decodable {
    public let diaryId: Int
    public let createdAt: String
    public let score: Int
}

extension DiaryCalendarDataDTO {
    func toDomain() -> DiaryCalendarVO {
        let diaryVOList = diaryList.map { diary in
            DiaryListVO(diaryId: diary.diaryId,
                        createdAt: diary.createdAt,
                        score: diary.score)
        }

        return DiaryCalendarVO(year: year,
                               month: month,
                               diaryList: diaryVOList)
    }
}
