//
//  HomeViewController.swift
//  Home
//
//  Created by 박지윤 on 7/1/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift
import Domain

public class HomeViewController: BaseViewController {
    let viewModel: HomeViewModel
    let scrollView = UIScrollView()
    let contentView = UIView()
    let logoImageView = UIImageView().then {
        $0.image = CommonUIAssets.smallLogo
        $0.contentMode = .scaleAspectFit
    }
    let homeView = HomeView()
    let homeProgressView = HomeProgressView()
    let homeQuizView = HomeQuizView()
    
    // 코스와 스텝 정보 저장
    private var currentCourse: CourseVO?
    private var stepList: [StepVO] = []

    public init(homeViewModel: HomeViewModel) {
        self.viewModel = homeViewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Bundle 디버깅
        CommonUIBundleHelper.debugBundle()
        
        bindActions()
        bindTransition()
        bindStepList()
        bindCourseData()
        bindCourseList()
        bindQuiz()
        bindPatchStepSuccess()
    }

    private func bindActions() {
        
    }

    private func bindTransition() {
        homeQuizView.onStartButtonTapped = { [weak self] indexPath in
            // getCourses에서 받아온 courseLv와 stepLv 사용
            guard let self = self,
                  let course = self.currentCourse,
                  indexPath.item < self.stepList.count else { return }
            
            let step = self.stepList[indexPath.item]
            self.viewModel.startStep(course: course.courseLv, step: step.stepLv)
        }
    }
    
    private func bindQuiz() {
        viewModel.quizSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] quiz in
                let quizViewController = QuizViewController(homeViewModel: self!.viewModel, quizData: quiz)
                quizViewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(quizViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindStepList() {
        viewModel.stepListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] stepList in
                self?.stepList = stepList
                self?.homeQuizView.setQuizList(stepList)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCourseData() {
        viewModel.courseSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] course in
                self?.currentCourse = course
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCourseList() {
        viewModel.courseListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] courseList in
                self?.homeProgressView.setCourseList(courseList)
                self?.homeProgressView.onNextCourseTapped = { [weak self] in
                    self?.updateCurrentCourseAndSteps()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateCurrentCourseAndSteps() {
        guard let currentCourse = homeProgressView.courseList.first(where: { $0.courseLv == homeProgressView.currentCourseIndex + 1 }) else { return }
        self.currentCourse = currentCourse
        homeQuizView.setQuizList(currentCourse.stepList)
    }
    
    private func bindPatchStepSuccess() {
        viewModel.patchStepSuccessSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                print("🔄 patchStep 성공 감지, getCourses 호출하여 뷰 재로딩")
                self?.viewModel.getCourses()
                // HomeProgressView의 nextButton 가시성 업데이트
                self?.homeProgressView.updateNextButtonVisibility()
            })
            .disposed(by: disposeBag)
    }

    public override func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }

    public override func setupHierarchy() {
        [logoImageView, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [homeView, homeProgressView, homeQuizView].forEach { contentView.addSubview($0) }
    }

    public override func setupDelegate() {
    }

    public override func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(65)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        homeView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }

        homeProgressView.snp.makeConstraints {
            $0.top.equalTo(homeView.snp.bottom)
            $0.centerX.equalToSuperview()
        }

        homeQuizView.snp.makeConstraints {
            $0.top.equalTo(homeProgressView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(330)
            $0.width.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
