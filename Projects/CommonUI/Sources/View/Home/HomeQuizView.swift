//
//  HomeQuizView.swift
//  CommonUI
//
//  Created by 박지윤 on 7/12/25.
//

import Domain
import UIKit
import SnapKit
import Then

open class HomeQuizView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var courses: [CourseVO] = []

    var courseLabel = UILabel()
    private var quizCollectionView: UICollectionView

    public override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        quizCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(frame: frame)

        setupCollectionView()
        initAttribute()
        initUI()
    }

    public func bind(course: CourseVO) {
        courseLabel.text = "\(course.courseLv ?? 1)단계 퀴즈"
    }

    func initAttribute() {
        self.backgroundColor = .clear

        courseLabel = courseLabel.then {
            $0.text = "1단계 퀴즈"
            $0.textColor = CommonUIAssets.LMBlack
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }
    }

    func initUI() {
        [courseLabel, quizCollectionView]
            .forEach { self.addSubview($0) }

        courseLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(14)
        }

        quizCollectionView.snp.makeConstraints {
            $0.top.equalTo(courseLabel.snp.bottom).offset(11)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(344)
            $0.height.equalTo(281)
        }
    }

    func setupCollectionView() {
        quizCollectionView.backgroundColor = .clear
        quizCollectionView.dataSource = self
        quizCollectionView.delegate = self
        quizCollectionView.register(HomeQuizCell.self, forCellWithReuseIdentifier: HomeQuizCell.identifier)
        quizCollectionView.isScrollEnabled = false
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeQuizCell.identifier, for: indexPath) as? HomeQuizCell else {
            return UICollectionViewCell()
        }
//        cell.configure(with: courses[indexPath.item])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 83)
    }
}
