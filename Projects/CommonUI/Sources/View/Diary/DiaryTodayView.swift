//
//  DiaryTodayView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit
import SnapKit
import Then

open class DiaryTodayView: UIView {
    // MARK: UI Components
    private(set) var dateLabel = UILabel().then {
        $0.textColor = CommonUIAssets.LMGray1
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
    }

    private(set) var emotionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
    }

    private let contentView = UIView()

    private(set) var contentLabel = UILabel().then {
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.textColor = CommonUIAssets.LMGray1
        $0.numberOfLines = 2
    }

    private(set) var diaryAddButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                               bgColor: CommonUIAssets.LMOrange3)

    // MARK: Properties
    var tap: (() -> Void)?
    public var tapDiaryAdd: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        print("initttt")
        configureSubviews()
        makeConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration
    func configureSubviews() {
        setLayer()
        setGesture()
        addButtonEvent()

        diaryAddButton = diaryAddButton.then {
            $0.setTitle("+ 일기 추가하기", for: .normal)
        }

        addSubview(dateLabel)
        addSubview(dividerView)
    }

    // MARK: - Public Methods

    /// 일기 데이터 설정 (String 날짜)
    public func setDiaryTodayData(date: String, diaryId: Int, score: Int, content: String) {
        setNonTodayView()
        setDateLabel(from: date)
        setEmotionAndContent(score: score, content: content)
    }

    /// 일기 데이터 설정 (Date 날짜)
    public func setDiaryTodayData(date: Date, diaryId: Int, score: Int, content: String) {
        setNonTodayView()
        setDateLabel(from: date)
        setEmotionAndContent(score: score, content: content)
    }

    /// 빈 일기 데이터 설정 (String 날짜)
    public func setDiaryTodayEmptyData(date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let dateObj = formatter.date(from: date) {
            setDiaryTodayEmptyData(date: dateObj)
        } else {
            setEmptyDataWithString(date: date)
        }
    }

    /// 빈 일기 데이터 설정 (Date 날짜)
    public func setDiaryTodayEmptyData(date: Date) {
        if Calendar.current.isDateInToday(date) {
            setTodayEmptyData(date: date)
        } else {
            setOtherDayEmptyData(date: date)
        }
    }

    // MARK: - Private Methods

    /// 오늘 일기 없을 때 - 일기 추가하기 버튼 표시
    private func setTodayEmptyData(date: Date) {
        setupEmptyState()
        setDateLabel(from: date)
        setupAddButton()
    }

    /// 다른 날 일기 없을 때 - 작성된 일기가 없습니다 표시
    private func setOtherDayEmptyData(date: Date) {
        setNonTodayView()
        setDateLabel(from: date)
        setEmptyEmotionAndContent()
    }

    /// String 날짜로 빈 데이터 설정 (fallback)
    private func setEmptyDataWithString(date: String) {
        setupEmptyState()
        dateLabel.text = date.convertDateString(fromFormat: "yyyy-MM-dd", toFormat: "yyyy년 MM월 dd일")
        setupAddButton()
    }

    /// 빈 상태 UI 설정
    private func setupEmptyState() {
        addSubview(diaryAddButton)
        emotionLabel.removeFromSuperview()
        contentLabel.removeFromSuperview()
    }

    /// 일기 추가 버튼 설정
    private func setupAddButton() {
        diaryAddButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(15)
            $0.width.equalToSuperview().inset(20)
        }
        diaryAddButton.addTarget(self, action: #selector(handleDiaryAddButton), for: .touchUpInside)
    }

    /// 날짜 라벨 설정 (String)
    private func setDateLabel(from date: String) {
        if date.contains("년") && date.contains("월") && date.contains("일") {
            dateLabel.text = date
        } else {
            dateLabel.text = date.convertDateString(fromFormat: "yyyy-MM-dd", toFormat: "yyyy년 MM월 dd일")
        }
    }

    /// 날짜 라벨 설정 (Date)
    private func setDateLabel(from date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        dateLabel.text = formatter.string(from: date)
    }

    /// 이모지와 내용 설정
    private func setEmotionAndContent(score: Int, content: String) {
        emotionLabel.text = getEmotionFromScore(score)
        contentLabel.text = content
    }

    /// 빈 상태 이모지와 내용 설정
    private func setEmptyEmotionAndContent() {
        emotionLabel.text = "🫥"
        contentLabel.text = "작성된 일기가 없습니다"
    }

    /// 일기가 있는 상태의 UI 설정
    private func setNonTodayView() {
        diaryAddButton.removeFromSuperview()

        addSubview(contentView)
        [emotionLabel, contentLabel].forEach { contentView.addSubview($0) }

        setupNonTodayConstraints()
    }

    /// 일기가 있는 상태의 제약조건 설정
    private func setupNonTodayConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(15)
            $0.centerX.width.equalToSuperview().inset(20)
            $0.height.equalTo(55)
            $0.bottom.equalToSuperview().inset(15)
        }

        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(25)
        }

        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(emotionLabel.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(15)
        }
    }

    /// 점수에 따른 이모지 반환
    private func getEmotionFromScore(_ score: Int) -> String {
        switch score {
        case 90...100: return "😊" // 매우 좋음
        case 80..<90:  return "🙂" // 좋음
        case 70..<80:  return "😐" // 보통
        case 60..<70:  return "😕" // 아쉬움
        default:       return "😢" // 슬픔
        }
    }

    // MARK: - Layout & Styling
    
    /// 뷰 레이어 스타일 설정
    private func setLayer() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.07
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 12
    }

    /// 제스처 설정
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    func makeConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }

    // MARK: - Event Handlers

    /// 버튼 이벤트 설정
    private func addButtonEvent() {
        diaryAddButton.addTarget(self, action: #selector(handleDiaryAddButton), for: .touchUpInside)
    }

    /// 탭 제스처 핸들러
    @objc private func handleTap() {
        tap?()
    }

    /// 일기 추가 버튼 핸들러
    @objc private func handleDiaryAddButton() {
        tapDiaryAdd?()
    }
}
