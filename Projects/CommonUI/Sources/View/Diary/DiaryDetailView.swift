//
//  DiaryDetailView.swift
//  CommonUI
//
//  Created by 박지윤 on 9/20/25.
//

import UIKit
import SnapKit
import Then
import Domain
import RxSwift

open class DiaryDetailView: UIView {
    
    // MARK: UI Components
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = true
    }

    private let contentView = UIView()

    private(set) var dateLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    private let dateUnderlineView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange1
    }
    
    // 원형 점수 표시기
    private let scoreContainerView = UIView()
    private let scoreCircleView = UIView().then {
        $0.backgroundColor = .yellow
        $0.layer.borderWidth = 8
        $0.layer.borderColor = CommonUIAssets.LMOrange1?.cgColor
        $0.layer.cornerRadius = 60
    }
    
    private let scoreProgressView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange3
        $0.layer.cornerRadius = 60
    }
    
    private let scoreLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = CommonUIAssets.LMBlack
        $0.textAlignment = .center
    }
    
    // 내가 쓴 일기 섹션
    private let originalSectionTitleLabel = UILabel().then {
        $0.text = "내가 쓴 일기"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let originalContentContainer = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange1?.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 12
    }
    
    private let originalContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
        $0.numberOfLines = 0
    }
    
    // 화살표
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.down")
        $0.tintColor = CommonUIAssets.LMGray3
        $0.contentMode = .scaleAspectFit
    }
    
    // 맞춤법 교정 결과 섹션
    private let revisedSectionTitleLabel = UILabel().then {
        $0.text = "맞춤법 교정 결과"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let revisedContentContainer = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange1?.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 12
    }
    
    private let revisedContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
        $0.numberOfLines = 0
    }
    
    // 맞춤법 오류 섹션
    private let errorSectionTitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let errorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fill
    }
    
    // AI 피드백 섹션
    private let feedbackSectionTitleLabel = UILabel().then {
        $0.text = "AI 피드백"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = CommonUIAssets.LMBlack
    }
    
    private let feedbackContainer = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange1?.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 12
    }
    
    private let feedbackLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = CommonUIAssets.LMBlack
        $0.numberOfLines = 0
    }
    
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
        backgroundColor = CommonUIAssets.LMWhite
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        // 원형 점수 표시기 설정
        scoreContainerView.addSubview(scoreCircleView)
        scoreContainerView.addSubview(scoreProgressView)
        scoreContainerView.addSubview(scoreLabel)
        
        // 원문 컨테이너 설정
        originalContentContainer.addSubview(originalContentLabel)
        
        // 수정문 컨테이너 설정
        revisedContentContainer.addSubview(revisedContentLabel)
        
        // 피드백 컨테이너 설정
        feedbackContainer.addSubview(feedbackLabel)
        
        [dateLabel, dateUnderlineView, scoreContainerView,
         originalSectionTitleLabel, originalContentContainer,
         arrowImageView, revisedSectionTitleLabel, revisedContentContainer,
         errorSectionTitleLabel, errorStackView,
         feedbackSectionTitleLabel, feedbackContainer]
            .forEach { contentView.addSubview($0) }
        
        setupConstraints()
    }
    
    private func bindEvents() {
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        dateUnderlineView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.centerX.width.equalTo(dateLabel)
            $0.height.equalTo(3)
        }
        
        scoreContainerView.snp.makeConstraints {
            $0.top.equalTo(dateUnderlineView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        
        scoreCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scoreProgressView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 내가 쓴 일기 섹션
        originalSectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scoreContainerView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        originalContentContainer.snp.makeConstraints {
            $0.top.equalTo(originalSectionTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        originalContentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        // 화살표
        arrowImageView.snp.makeConstraints {
            $0.top.equalTo(originalContentContainer.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        // 맞춤법 교정 결과 섹션
        revisedSectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(arrowImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        revisedContentContainer.snp.makeConstraints {
            $0.top.equalTo(revisedSectionTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        revisedContentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        // 맞춤법 오류 섹션
        errorSectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(revisedContentContainer.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        errorStackView.snp.makeConstraints {
            $0.top.equalTo(errorSectionTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // AI 피드백 섹션
        feedbackSectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(errorStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        feedbackContainer.snp.makeConstraints {
            $0.top.equalTo(feedbackSectionTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }

        feedbackLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: Public Methods
    public func configure(with diary: DiaryVO) {
        self.diaryData = diary
        
        // 날짜 설정
        dateLabel.text = diary.createdAt

        // 원문 설정
        originalContentLabel.text = diary.originContent
        
        // 수정문 설정 (하이라이트 포함)
        setupRevisedContent(diary.spellingDto.revisedContent, revisions: diary.spellingDto.revisions)
        
        // 점수 설정
        scoreLabel.text = "\(diary.spellingDto.score)점"
        setupScoreProgress(score: diary.spellingDto.score)
        
        // 오류 섹션 설정
        setupErrorSection(revisions: diary.spellingDto.revisions)
        
        // 피드백 설정
        feedbackLabel.text = diary.feedback
    }

    private func setupScoreProgress(score: Int) {
        let progress = CGFloat(score) / 100.0
        let angle = progress * 2 * .pi - .pi / 2 // -90도부터 시작
        
        // 원형 프로그레스 애니메이션
        let path = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60),
                               radius: 52,
                               startAngle: -.pi / 2,
                               endAngle: angle,
                               clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = CommonUIAssets.LMOrange1?.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.lineCap = .round
        
        scoreProgressView.layer.sublayers?.removeAll()
        scoreProgressView.layer.addSublayer(shapeLayer)
    }
    
    private func setupRevisedContent(_ revisedContent: String, revisions: [RevisionVO]) {
        let attributedString = NSMutableAttributedString(string: revisedContent)
        
        for revision in revisions {
            let range = (revisedContent as NSString).range(of: revision.revisedContent)
            if range.location != NSNotFound {
                attributedString.addAttribute(.backgroundColor,
                                            value: CommonUIAssets.LMOrange1?.withAlphaComponent(0.3) ?? UIColor.orange.withAlphaComponent(0.3),
                                            range: range)
            }
        }
        
        revisedContentLabel.attributedText = attributedString
    }
    
    private func setupErrorSection(revisions: [RevisionVO]) {
        errorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if revisions.isEmpty {
            errorSectionTitleLabel.text = "맞춤법 오류 0개"
            let noErrorsLabel = UILabel().then {
                $0.text = "완벽한 문장이에요! 🎉"
                $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                $0.textColor = CommonUIAssets.LMOrange1
                $0.textAlignment = .center
            }
            errorStackView.addArrangedSubview(noErrorsLabel)
        } else {
            errorSectionTitleLabel.text = "맞춤법 오류 \(revisions.count)개"
            
            for revision in revisions {
                let errorView = createErrorView(revision)
                errorStackView.addArrangedSubview(errorView)
            }
        }
    }
    
    private func createErrorView(_ revision: RevisionVO) -> UIView {
        let containerView = UIView()
        
        let originalBox = UIView().then {
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = CommonUIAssets.LMOrange1?.withAlphaComponent(0.3).cgColor
            $0.layer.cornerRadius = 8
        }
        
        let originalLabel = UILabel().then {
            $0.text = revision.originContent
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = CommonUIAssets.LMBlack
            $0.textAlignment = .center
        }
        
        let arrowImageView = UIImageView().then {
            $0.image = UIImage(systemName: "arrow.right")
            $0.tintColor = CommonUIAssets.LMOrange1
            $0.contentMode = .scaleAspectFit
        }
        
        let revisedBox = UIView().then {
            $0.backgroundColor = CommonUIAssets.LMOrange1?.withAlphaComponent(0.3)
            $0.layer.cornerRadius = 8
        }
        
        let revisedLabel = UILabel().then {
            $0.text = revision.revisedContent
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = CommonUIAssets.LMBlack
            $0.textAlignment = .center
        }
        
        [originalBox, originalLabel, arrowImageView, revisedBox, revisedLabel]
            .forEach { containerView.addSubview($0) }
        
        originalBox.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        originalLabel.snp.makeConstraints {
            $0.edges.equalTo(originalBox).inset(8)
        }
        
        // originalBox의 너비를 originalLabel의 내용에 따라 동적으로 설정
        originalBox.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(60) // 최소 너비
            $0.width.lessThanOrEqualTo(120)   // 최대 너비
        }
        
        arrowImageView.snp.makeConstraints {
            $0.leading.equalTo(originalBox.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }
        
        revisedBox.snp.makeConstraints {
            $0.leading.equalTo(arrowImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        revisedLabel.snp.makeConstraints {
            $0.edges.equalTo(revisedBox).inset(8)
        }
        
        // revisedBox의 너비를 revisedLabel의 내용에 따라 동적으로 설정
        revisedBox.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(60) // 최소 너비
            $0.width.lessThanOrEqualTo(120)   // 최대 너비
        }
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        return containerView
    }
    
}
