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
        $0.text = "ddd"
        $0.textColor = CommonUIAssets.LMGray1
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
    }

    private(set) var emotionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
    }

    private(set) var contentLabel = UILabel().then {
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.textColor = CommonUIAssets.LMGray1
        $0.numberOfLines = 2
    }

    private(set) var diaryAddButton = LMButton(textColor: CommonUIAssets.LMGray1,
                                               bgColor: CommonUIAssets.LMOrange3)

    // MARK: Properties
    var tap: (() -> Void)?
    var tapDiaryAdd: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
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
            $0.backgroundColor = CommonUIAssets.LMOrange3
            $0.layer.cornerRadius = 12
            $0.setTitle("+ 일기 추가하기", for: .normal)
            $0.setTitleColor(CommonUIAssets.LMGray1, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        }

        addSubview(dateLabel)
        addSubview(dividerView)
    }

    func setDiaryTodayEmptyData(date: String) {
        addSubview(diaryAddButton)
        emotionLabel.removeFromSuperview()
        contentLabel.removeFromSuperview()

        dateLabel.text = date.convertDateString(fromFormat: "yyyy-MM-dd",
                                                toFormat: "yyyy년 MM월 dd일")

        diaryAddButton.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(9)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }

    func setDiaryEmptyData(date: String) {
        setNonTodayView()

        dateLabel.text = date.convertDateString(fromFormat: "yyyy-MM-dd",
                                                toFormat: "yyyy년 MM월 dd일")
        emotionLabel.text = "🫥"
        contentLabel.text = "작성된 일기가 없습니다"
    }

//    func setDiaryTodayData(data: DiaryDTO) {
//        setNonTodayView()
//
//        dateLabel.text = data.date
//        emotionLabel.text = Emoticon.mapEmoticonImage(data.emotion)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 4
//
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 13, weight: .light),
//            .paragraphStyle: paragraphStyle
//        ]
//
//        let content = data.content
//        let attributedString = NSAttributedString(string: content, attributes: attributes)
//
//        contentLabel.attributedText = attributedString
//    }

    private func setNonTodayView() {
        diaryAddButton.removeFromSuperview()

        addSubview(emotionLabel)
        addSubview(contentLabel)

        emotionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22)
            $0.centerY.equalTo(contentLabel)
            $0.width.equalTo(25)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(21)
            $0.leading.equalTo(emotionLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }

    // MARK: Layout
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

    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        tap?()
    }

    func makeConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
        }

        dividerView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.height.equalTo(1)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }

    // MARK: Event
    private func addButtonEvent() {
        diaryAddButton.addTarget(self, action: #selector(handleDiaryAddButton), for: .touchUpInside)
    }

    @objc
    private func handleDiaryAddButton() {
        tapDiaryAdd?()
    }
}
