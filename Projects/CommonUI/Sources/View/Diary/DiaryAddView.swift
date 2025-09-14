//
//  DiaryAddView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/14/25.
//

import UIKit
import SnapKit
import Then

open class DiaryAddView: UIView {
    
//    // MARK: Properties
//    private let placeholder = LMString.diaryAddPlaceholder
//
//    // MARK: UI Components
//    private(set) var dateLabel = UILabel().then {
//        $0.text = Date().getToday()
//        $0.textColor = .black
//        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//    }
//
//    private let dateUnderlineView = UIView().then {
//        $0.backgroundColor = .lmOrange1
//    }
//
//    private let diaryTextView = UITextView().then {
//        $0.backgroundColor = .lmOrange1.withAlphaComponent(0.13)
//        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        $0.layer.cornerRadius = 12
//        $0.textContainerInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
//    }
//
//    private let textNumLabel = UILabel().then {
//        $0.text = "0 / 500"
//        $0.font = UIFont.systemFont(ofSize: 15, weight: .light)
//        $0.textColor = .lmGray2
//        $0.textAlignment = .right
//    }
//
//    private let diaryAddButton = BaseButton().then {
//        $0.setDefaultButton(title: "일기 작성하기",
//                            titleColor: .black,
//                            backgroundColor: .lmOrange1)
//    }
//
//    // MARK: Properties
//    var tapAdd: (() -> Void)?
//
//    // MARK: Configuration
//    override func configureSubviews() {
//        backgroundColor = .white
//        addButtonEvent()
//        setTextView()
//
//        addSubview(dateLabel)
//        addSubview(dateUnderlineView)
//        addSubview(diaryTextView)
//        addSubview(textNumLabel)
//        addSubview(diaryAddButton)
//    }
//
//    // MARK: Layout
//    override func makeConstraints() {
//        dateLabel.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
//            $0.leading.equalToSuperview().inset(20)
//        }
//
//        dateUnderlineView.snp.makeConstraints {
//            $0.top.equalTo(dateLabel.snp.bottom)
//            $0.centerX.width.equalTo(dateLabel)
//            $0.height.equalTo(3)
//        }
//
//        diaryTextView.snp.makeConstraints {
//            $0.top.equalTo(dateUnderlineView.snp.bottom).offset(17)
//            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.width.equalToSuperview().inset(20)
//            $0.bottom.equalTo(diaryAddButton.snp.top).offset(-30)
//        }
//
//        textNumLabel.snp.makeConstraints {
//            $0.trailing.bottom.equalTo(diaryTextView).inset(25)
//        }
//
//        diaryAddButton.snp.makeConstraints {
//            $0.width.equalToSuperview().inset(20)
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalTo(safeAreaLayoutGuide).inset(15)
//        }
//    }
//
//    // MARK: Event
//    private func addButtonEvent() {
//        diaryAddButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
//    }
//
//    @objc
//    private func handleAddButton() {
//        tapAdd?()
//    }
//}
//
//extension DiaryAddView: UITextViewDelegate {
//    private func setTextView() {
//        diaryTextView.delegate = self
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 4
//
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.systemFont(ofSize: 15, weight: .light),
//            .foregroundColor: UIColor.lmGray2,
//            .paragraphStyle: paragraphStyle
//        ]
//        
//        let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
//
//        diaryTextView.attributedText = attributedString
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        if diaryTextView.text.count > 500 {
//            diaryTextView.deleteBackward()
//        }
//
//        textNumLabel.text = "\(diaryTextView.text.count) / 500"
//
//        let attributedString = NSMutableAttributedString(string: "\(diaryTextView.text.count) / 500")
//        attributedString.addAttribute(.foregroundColor, value: UIColor.lmOrange1, range: ("\(diaryTextView.text.count) / 500" as NSString).range(of:"\(diaryTextView.text.count)"))
//        textNumLabel.attributedText = attributedString
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if diaryTextView.text.isEmpty {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 4
//
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 15, weight: .light),
//                .foregroundColor: UIColor.lmGray2,
//                .paragraphStyle: paragraphStyle
//            ]
//            
//            let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
//
//            diaryTextView.attributedText = attributedString
//        } else if diaryTextView.text == placeholder {
//            diaryTextView.textColor = .black
//            diaryTextView.text = nil
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if diaryTextView.text.isEmpty {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineSpacing = 4
//
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 15, weight: .light),
//                .foregroundColor: UIColor.lmGray2,
//                .paragraphStyle: paragraphStyle
//            ]
//            
//            let attributedString = NSAttributedString(string: placeholder, attributes: attributes)
//
//            diaryTextView.attributedText = attributedString
//        }
//    }
//
//    func getDiaryText() -> String? {
//        let text = diaryTextView.text
//        return text == placeholder ? nil : text
//    }
}
