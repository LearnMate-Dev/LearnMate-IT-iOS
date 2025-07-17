//
//  QuizViewController.swift
//  Home
//
//  Created by 박지윤 on 7/12/25.
//

import Domain
import CommonUI
import UIKit
import SnapKit
import RxSwift

public class QuizViewController: UIViewController {
    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             isRightButtonHidden: true)
    let progressView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMOrange1
        $0.layer.cornerRadius = 3
    }
    let progressEntireView = UIView().then {
        $0.backgroundColor = CommonUIAssets.LMGray5
        $0.layer.cornerRadius = 3
    }
    let scrollView = UIScrollView()
    let quizStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 18
    }
    
    let optionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    var currentQuestionIndex = 0
    var currentOptionStackView: UIStackView?
    var currentFeedbackText = ""
    var quizData: QuizVO?
    var currentQuiz: QuizDetailVO?

    public init(quizData: QuizVO) {
        self.quizData = quizData
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindDatas()
        if let quizData = quizData {
            showSituation(index: 0)
        }
    }
    
    public func setupViewProperty() {
        view.backgroundColor = CommonUIAssets.LMOrange4

        currentOptionStackView = currentOptionStackView?.then {
            $0.backgroundColor = .orange
            $0.axis = .vertical
            $0.spacing = 0
        }
    }

    public func setupHierarchy() {
        [navigationBar, progressEntireView, progressView, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(quizStackView)
    }
    
    public func setupDelegate() {
    }
    
    public func setupLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.centerX.equalToSuperview()
        }
        
        progressEntireView.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.width.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(progressEntireView.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        quizStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
    }
    
    func bindDatas() {
        if let quizData = quizData {
            navigationBar.setupViewProperty(title: quizData.stepTitle)
        } else {
            navigationBar.setupViewProperty(title: "처음 보는 사람과 인사하기")
        }
    }

    func showSituation(index: Int) {
        guard let quizData = quizData, index < quizData.quizList.count else {
            showEndMessage()
            return
        }
        
        currentQuiz = quizData.quizList[index]
        let situationText = quizData.quizList[index].quizSituation
        
        if !situationText.isEmpty {
            let situationView = QuizView(text: situationText, type: .situation)
            quizStackView.addArrangedSubview(situationView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showQuestion(index: index)
            }
        } else {
            showQuestion(index: index)
        }
    }
    
    func showQuestion(index: Int) {
        guard index == self.currentQuestionIndex,
              let quizData = quizData,
              index < quizData.quizList.count else { return }
        
        let currentQuiz = quizData.quizList[index]
        
        let questionView = QuizView(text: currentQuiz.quiz, type: .question)
        quizStackView.addArrangedSubview(questionView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let optionStack = UIStackView().then {
                $0.axis = .vertical
                $0.spacing = 0
            }

            for (i, option) in currentQuiz.quizOptions.enumerated() {
                let optionView = OptionView(text: option.answer)
                optionView.tag = i
                optionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleOptionTap(_:))))
                optionView.isUserInteractionEnabled = true
                optionStack.addArrangedSubview(optionView)
            }

            self.quizStackView.addArrangedSubview(optionStack)
            self.currentQuestionIndex = index
            self.currentOptionStackView = optionStack
        }
    }
    
    @objc func handleOptionTap(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        guard let optionStack = currentOptionStackView,
              let quizData = quizData,
              currentQuestionIndex < quizData.quizList.count else { return }

        let selectedIndex = selectedView.tag
        let currentQuiz = quizData.quizList[currentQuestionIndex]
        let correctIndex = currentQuiz.correctIdx

        for view in optionStack.arrangedSubviews {
            if view != selectedView {
                optionStack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        if selectedIndex == correctIndex {
            let feedbackText = currentQuiz.quizOptions[selectedIndex].description
            let feedback = AnswerView(text: feedbackText, type: .correct)
            quizStackView.addArrangedSubview(feedback)

            updateProgress()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let nextIndex = self.currentQuestionIndex + 1
                self.currentQuestionIndex = nextIndex
                self.showSituation(index: nextIndex)
            }
        } else {
            let feedback = AnswerView(text: "다시 한 번 생각해보세요.", type: .wrong)
            quizStackView.addArrangedSubview(feedback)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let currentQuiz = quizData.quizList[self.currentQuestionIndex]
                let optionStack = UIStackView().then {
                    $0.axis = .vertical
                    $0.spacing = 0
                }

                for (i, option) in currentQuiz.quizOptions.enumerated() {
                    let optionView = OptionView(text: option.answer)
                    optionView.tag = i
                    optionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleOptionTap(_:))))
                    optionView.isUserInteractionEnabled = true
                    optionStack.addArrangedSubview(optionView)
                }

                self.quizStackView.addArrangedSubview(optionStack)
                self.currentOptionStackView = optionStack
            }
        }
    }
    
    func showEndMessage() {
        showQuizCompleteAlert()
    }
    
    func showQuizCompleteAlert() {
        let alertView = QuizCompleteAlertView()
        alertView.show(in: view)
    }
    
    private func updateProgress() {
        guard let quizData = quizData else { return }
        
        let totalQuestions = quizData.quizList.count
        let completedQuestions = currentQuestionIndex + 1
        
        let totalWidth = UIScreen.main.bounds.width - 40
        
        let progressPerQuestion = totalWidth / CGFloat(totalQuestions)
        let currentProgress = progressPerQuestion * CGFloat(completedQuestions)
        
        UIView.animate(withDuration: 0) {
            self.progressView.snp.updateConstraints {
                $0.width.equalTo(currentProgress)
            }
            self.view.layoutIfNeeded()
        }
    }
}
