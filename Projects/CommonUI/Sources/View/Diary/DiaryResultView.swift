//
//  DiaryResultView.swift
//  CommonUI
//
//  Created by 박지윤 on 1/7/25.
//

import UIKit
import SnapKit
import Then
import Domain
import RxSwift

open class DiaryResultView: UIView {
    
    // MARK: UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let originalContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMGray1
        $0.numberOfLines = 0
    }
    
    private let revisedContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
        $0.numberOfLines = 0
    }
    
    private let scoreLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = CommonUIAssets.LMOrange1
        $0.textAlignment = .center
    }
    
    private let revisionsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fill
    }
    
    private let feedbackLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
        $0.numberOfLines = 0
        $0.backgroundColor = CommonUIAssets.LMOrange1?.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 12
    }
    
    private var saveDiaryButton = LMButton(textColor: CommonUIAssets.LMBlack,
                                          bgColor: CommonUIAssets.LMOrange1)
    
    // MARK: Properties
    private var diaryData: DiaryVO?
    let disposeBag = DisposeBag()
    
    // MARK: Public Properties
    public var onSaveButtonTapped: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindEvents()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupUI() {
        backgroundColor = CommonUIAssets.LMOrange4
        
        // 버튼 설정
        saveDiaryButton = saveDiaryButton.then {
            $0.setTitle("일기 저장하기", for: .normal)
        }
        
        addSubview(scrollView)
        addSubview(saveDiaryButton)
        scrollView.addSubview(contentView)
        
        [dateLabel, originalContentLabel, revisedContentLabel, scoreLabel, revisionsStackView, feedbackLabel]
            .forEach { contentView.addSubview($0) }
        
        setupConstraints()
    }
    
    private func bindEvents() {
        saveDiaryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.onSaveButtonTapped?()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveDiaryButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        saveDiaryButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        originalContentLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        revisedContentLabel.snp.makeConstraints {
            $0.top.equalTo(originalContentLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(revisedContentLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        revisionsStackView.snp.makeConstraints {
            $0.top.equalTo(scoreLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        feedbackLabel.snp.makeConstraints {
            $0.top.equalTo(revisionsStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: Public Methods
    public func configure(with diary: DiaryVO) {
        self.diaryData = diary
        
        dateLabel.text = diary.createdAt
        originalContentLabel.text = "원문: \(diary.originContent)"
        revisedContentLabel.text = "수정문: \(diary.spellingDto.revisedContent)"
        scoreLabel.text = "점수: \(diary.spellingDto.score)점"
        
        setupRevisions(diary.spellingDto.revisions)
        setupFeedback(diary.feedback)
    }
    
    private func setupRevisions(_ revisions: [RevisionVO]) {
        revisionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if revisions.isEmpty {
            let noRevisionsLabel = UILabel().then {
                $0.text = "수정사항이 없습니다. 완벽한 문장이에요! 🎉"
                $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                $0.textColor = CommonUIAssets.LMOrange1
                $0.textAlignment = .center
            }
            revisionsStackView.addArrangedSubview(noRevisionsLabel)
        } else {
            let titleLabel = UILabel().then {
                $0.text = "📝 수정사항"
                $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                $0.textColor = CommonUIAssets.LMBlack
            }
            revisionsStackView.addArrangedSubview(titleLabel)
            
            for revision in revisions {
                let revisionView = createRevisionView(revision)
                revisionsStackView.addArrangedSubview(revisionView)
            }
        }
    }
    
    private func createRevisionView(_ revision: RevisionVO) -> UIView {
        let containerView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 4
        }
        
        let categoryLabel = UILabel().then {
            $0.text = revision.category
            $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            $0.textColor = CommonUIAssets.LMOrange1
        }
        
        let originalTextLabel = UILabel().then {
            $0.text = "❌ \(revision.originContent)"
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textColor = .systemRed
        }
        
        let revisedTextLabel = UILabel().then {
            $0.text = "✅ \(revision.revisedContent)"
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0.textColor = .systemGreen
        }
        
        let commentLabel = UILabel().then {
            $0.text = revision.comment
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.textColor = CommonUIAssets.LMGray1
            $0.numberOfLines = 0
        }
        
        let examplesLabel = UILabel().then {
            $0.text = "예시: \(revision.examples.joined(separator: ", "))"
            $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            $0.textColor = CommonUIAssets.LMGray3
            $0.numberOfLines = 0
        }
        
        [categoryLabel, originalTextLabel, revisedTextLabel, commentLabel, examplesLabel]
            .forEach { containerView.addSubview($0) }
        
        categoryLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        originalTextLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        revisedTextLabel.snp.makeConstraints {
            $0.top.equalTo(originalTextLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(revisedTextLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        examplesLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        return containerView
    }
    
    private func setupFeedback(_ feedback: String) {
        feedbackLabel.text = "💬 피드백\n\n\(feedback)"
    }
}
