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
    
    // 첫 진입 여부를 추적하는 플래그
    private var isFirstAppearance = true
    
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
        
        // 첫 진입 시에만 오늘 날짜의 일기 데이터 로드
        if isFirstAppearance {
            // 오늘 날짜의 일기 데이터 로드
            viewModel.getDiary(date: today)
            isFirstAppearance = false
        }
        
        // 매번 캘린더 데이터 리로드 (일기 저장 후 돌아올 때 포함)
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
        
        // 첫 진입 시 오늘 날짜로 초기 상태 설정
        setupInitialState()
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
        
        // 특정 날짜 일기 데이터 바인딩
        viewModel.diarySubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] diary in
                print("📱 DiaryViewController: diarySubject 수신됨 - \(diary)")
                self?.updateDiaryTodayViewWithSelectedDate(diary: diary)
            })
            .disposed(by: disposeBag)
        
        // 특정 날짜 일기 에러 처리
        viewModel.diaryErrorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("❌ 특정 날짜 일기 로드 실패: \(error)")
            })
            .disposed(by: disposeBag)
        
        // 특정 날짜에 일기가 없을 때 처리
        viewModel.diaryEmptySubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] date in
                self?.updateDiaryTodayViewWithEmptyData(date: date)
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
        
        // DiaryTodayView의 일기 상세 보기 이벤트 바인딩
        diaryView.diaryTodayView.tapDiaryDetail = { [weak self] diaryData in
            if let diaryData = diaryData {
                self?.presentDiaryDetailView(diaryData: diaryData)
            }
        }
        
        // 캘린더 날짜 클릭 이벤트 바인딩
        diaryView.calendarView.tapDay = { [weak self] date in
            self?.viewModel.getDiary(date: date)
        }
        
        // 월 변경 이벤트 바인딩
        diaryView.tapPrevious = { [weak self] year, month in
            self?.viewModel.getDiaryCalendar(year: year, month: month)
        }
        
        diaryView.tapNext = { [weak self] year, month in
            self?.viewModel.getDiaryCalendar(year: year, month: month)
        }
    }

    private func setupInitialState() {
        // 첫 진입 시 오늘 날짜로 DiaryTodayView 초기 상태 설정
        let today = Date()
        diaryView.diaryTodayView.setDiaryTodayEmptyData(date: today)
        
        // 캘린더에서 오늘 날짜 선택 상태로 설정
        diaryView.calendarView.setSelectedDate(today)
    }
    
    private func presentNewDiaryView() {
        let diaryAddViewController = DiaryAddViewController(diaryViewModel: viewModel)
        diaryAddViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryAddViewController, animated: true)
    }
    
    private func presentDiaryDetailView(diaryData: DiaryVO) {
        let diaryDetailViewController = DiaryDetailViewController(diaryViewModel: viewModel, diaryData: diaryData)
        diaryDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    private func updateDiaryTodayView(with calendarData: DiaryCalendarVO) {
        // 캘린더 데이터로 이모지 정보 업데이트
        var emotionData: [Int: String] = [:]
        for diary in calendarData.diaryList {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: diary.createdAt) {
                let day = Calendar.current.component(.day, from: date)
                // 점수에 따른 이모지 매핑 (예시)
                let emotion = getEmotionForScore(diary.score)
                emotionData[day] = emotion
            }
        }
        diaryView.calendarView.setEmotionData(emotionData)
        
        // 첫 진입 시에만 오늘 날짜로 DiaryTodayView 업데이트
        guard isFirstAppearance else { return }
        
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
            // 오늘 일기가 없는 경우 - 오늘 날짜로 빈 상태 설정
            diaryView.diaryTodayView.setDiaryTodayEmptyData(date: today)
        }
    }
    
    private func getEmotionForScore(_ score: Int) -> String {
        switch score {
        case 90...100:
            return "🥳" // 파티 모자
        case 80..<90:
            return "😊" // 웃는 얼굴
        case 70..<80:
            return "😐" // 무표정한 얼굴
        case 60..<70:
            return "😕" // 약간 찡그린 얼굴
        default:
            return "😢" // 우는 얼굴
        }
    }
    
    private func updateDiaryTodayViewWithSelectedDate(diary: DiaryVO) {
        print("📱 updateDiaryTodayViewWithSelectedDate 호출됨")
        print("📱 diary.createdAt: \(diary.createdAt)")
        print("📱 diary.score: \(diary.spellingDto.score)")
        print("📱 diary.content: \(diary.spellingDto.revisedContent)")

        // 선택된 날짜의 일기 데이터로 DiaryTodayView 업데이트
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        if let date = formatter.date(from: diary.createdAt) {
            print("📱 Date 파싱 성공: \(date)")
            diaryView.diaryTodayView.setDiaryTodayData(
                date: date,
                diaryId: diary.diaryId,
                score: diary.spellingDto.score,
                content: diary.spellingDto.revisedContent
            )
        } else {
            print("📱 Date 파싱 실패, 문자열로 직접 설정")
            // 날짜 파싱 실패 시 문자열로 직접 설정
            diaryView.diaryTodayView.setDiaryTodayData(
                date: diary.createdAt,
                diaryId: diary.diaryId,
                score: diary.spellingDto.score,
                content: diary.spellingDto.revisedContent
            )
        }
        
        // DiaryVO 데이터 설정 (탭 이벤트용)
        diaryView.diaryTodayView.setDiaryData(diary)
    }

    private func updateDiaryTodayViewWithEmptyData(date: Date) {
        print("📱 updateDiaryTodayViewWithEmptyData 호출됨")
        print("📱 date: \(date)")
        print("📱 오늘 날짜인가: \(Calendar.current.isDateInToday(date))")
        
        // 선택된 날짜에 일기가 없을 때 DiaryTodayView 업데이트
        diaryView.diaryTodayView.setDiaryTodayEmptyData(date: date)
    }
}
