//
//  QuizViewController.swift
//  Home
//
//  Created by 박지윤 on 7/12/25.
//

import CommonUI
import UIKit
import SnapKit
import RxSwift

public class QuizViewController: UIViewController {
    let navigationBar = DefaultNavigationBar(leftImage: CommonUIAssets.IconBack ?? nil,
                                             rightImage: nil,
                                             isRightButtonHidden: true)
    let progressView = UIView()
    let progressEntireView = UIView().then {
        $0.backgroundColor = .gray
        //        $0.backgroundColor = CommonUIAssets.LMGray5
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
    var correctAnswers = [1, 1, 0] // 정답 인덱스

    //    public init(homeViewModel: HomeViewModel) {
    //        self.viewModel = homeViewModel
    //        super.init()
    //    }
    
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
        showSituation(index: 0)
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
        [navigationBar, progressView, progressEntireView, scrollView].forEach { view.addSubview($0) }
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
        navigationBar.setupViewProperty(title: "처음 보는 사람과 인사하기")
    }

    func showSituation(index: Int) {
        let situations = [
            "당신은 체험 첫날, 안내 데스크에 도착했어요.\n직원 한 분이 다가오며 웃으면서 말을 걸어요.",
            "점심 시간이 가까워지고 있어요.\n주변 사람들이 슬슬 자리를 정리하고 있어요.",
            "동료가 다가와서 식사에 대해 물어봐요.\n어떤 반응을 할까요?"
        ]

        guard index < situations.count else {
            showEndMessage()
            return
        }

        let situationView = QuizView(text: situations[index], type: .situation)
        quizStackView.addArrangedSubview(situationView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showQuestion(index: index)
        }
    }
    
    func showQuestion(index: Int) {
        guard index == self.currentQuestionIndex else { return }
        
        let questions = [
            "안녕하세요. 혹시 실습생이신가요?",
            "오늘 어떤 부서에 배정받으셨나요?",
            "점심은 보통 몇 시에 먹을까요?"
        ]
        
        let options = [
            ["응. 너는 누구야?", "네, 안녕하세요.", "왜요?"],
            ["몰라요.", "총무팀이요!", "어디더라?"],
            ["12시쯤이요.", "저녁이요?", "모르겠어요."]
        ]
        
        let feedbacks = [
            "처음 본 사람에게 반말은 예의에 어긋나요.",
            "부서를 정확히 말하는 게 좋아요.",
            "점심 시간은 보통 12시입니다."
        ]
        
        guard index < questions.count else {
            self.showEndMessage()
            return
        }

        let questionView = QuizView(text: questions[index], type: .question)
        quizStackView.addArrangedSubview(questionView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let optionStack = UIStackView().then {
                $0.axis = .vertical
                $0.spacing = 0
            }

            for i in 0..<3 {
                let optionView = OptionView(text: options[index][i])
                optionView.tag = i
                optionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleOptionTap(_:))))
                optionView.isUserInteractionEnabled = true
                optionStack.addArrangedSubview(optionView)
            }

            self.quizStackView.addArrangedSubview(optionStack)
            self.currentQuestionIndex = index
            self.currentOptionStackView = optionStack
            self.currentFeedbackText = feedbacks[index]
        }
    }
    
    @objc func handleOptionTap(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        guard let optionStack = currentOptionStackView else { return }

        let selectedIndex = selectedView.tag
        let correctIndex = correctAnswers[currentQuestionIndex]

        for view in optionStack.arrangedSubviews {
            if view != selectedView {
                optionStack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }

        if selectedIndex == correctIndex {
            let feedback = AnswerView(text: currentFeedbackText, type: .correct)
            quizStackView.addArrangedSubview(feedback)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let nextIndex = self.currentQuestionIndex + 1
                self.currentQuestionIndex = nextIndex
                self.showSituation(index: nextIndex)
            }
        } else {
            let feedback = AnswerView(text: "다시 한 번 생각해보세요.", type: .wrong)
            quizStackView.addArrangedSubview(feedback)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let options = [
                    ["응. 너는 누구야?", "네, 안녕하세요.", "왜요?"],
                    ["몰라요.", "총무팀이요!", "어디더라?"],
                    ["12시쯤이요.", "저녁이요?", "모르겠어요."]
                ]
                let index = self.currentQuestionIndex
                let optionStack = UIStackView().then {
                    $0.axis = .vertical
                    $0.spacing = 0
                }

                for i in 0..<3 {
                    let optionView = OptionView(text: options[index][i])
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
}
