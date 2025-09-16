//
//  DiaryCalendarVO.swift
//  Domain
//
//  Created by 박지윤 on 9/16/25.
//


public struct DiaryCalendarVO {
    public let year: Int
    public let month: Int
    public let diaryList: [DiaryListVO]

    public init(year: Int,
                month: Int,
                diaryList: [DiaryListVO]) {
        self.year = year
        self.month = month
        self.diaryList = diaryList
    }
}

public struct DiaryListVO {
    public let diaryId: Int
    public let createdAt: String
    public let score: Int

    public init(diaryId: Int,
                createdAt: String,
                score: Int) {
        self.diaryId = diaryId
        self.createdAt = createdAt
        self.score = score
    }
}
