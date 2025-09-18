//
//  DiaryViewController.swift
//  Diary
//
//  Created by 박지윤 on 7/1/25.
//

import UIKit
import CommonUI
import RxSwift
import Domain

public class DiaryViewController: BaseViewController {
    let viewModel: DiaryViewModel
    let diaryView = DiaryView()
    
    public init(diaryViewModel: DiaryViewModel) {
        self.viewModel = diaryViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let today = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        viewModel.getDiaryCalendar(year: year, month: month)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CommonUIAssets.LMOrange4
        navigationController?.navigationBar.isHidden = true
        setupViewProperty()
        setupHierarchy()
        setupLayout()
        bindData()
        bindEvents()
    }

    public override func setupViewProperty() {
    }
    
    public override func setupHierarchy() {
        view.addSubview(diaryView)
    }
    
    public override func setupDelegate() {
    }
    
    public override func setupLayout() {
        diaryView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindData() {
        // 캘린더 데이터 바인딩
        viewModel.diaryCalendarSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] calendarData in
                self?.updateDiaryTodayView(with: calendarData)
            })
            .disposed(by: disposeBag)
        
        // 캘린더 에러 처리
        viewModel.diaryCalendarErrorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("❌ 캘린더 데이터 로드 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEvents() {
        diaryView.onAddButtonTapped = { [weak self] in
            self?.presentNewDiaryView()
        }
        
        // DiaryTodayView의 일기 추가 버튼 이벤트 바인딩
        diaryView.diaryTodayView.tapDiaryAdd = { [weak self] in
            self?.presentNewDiaryView()
        }
    }

    private func presentNewDiaryView() {
        let diaryAddViewController = DiaryAddViewController(diaryViewModel: viewModel)
        self.navigationController?.pushViewController(diaryAddViewController, animated: true)
    }
    
    private func updateDiaryTodayView(with calendarData: DiaryCalendarVO) {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        // 오늘 날짜의 일기가 있는지 확인
        let todayDiary = calendarData.diaryList.first { diary in
            diary.createdAt.hasPrefix(todayString)
        }
        
        if let diary = todayDiary {
            // 오늘 일기가 있는 경우
            diaryView.diaryTodayView.setDiaryTodayData(
                date: todayString,
                diaryId: diary.diaryId,
                score: diary.score,
                content: diary.createdAt
            )
        } else {
            // 오늘 일기가 없는 경우
            diaryView.diaryTodayView.setDiaryTodayEmptyData(date: todayString)
        }
    }
}
