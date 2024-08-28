//
//  CalendarViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import Foundation
import RxSwift

final class CalendarViewModel: BaseViewModel {
    // MARK: - Properties

    private let calendar = Calendar.current
    private var components = DateComponents()
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }

    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: Date())
    }

    // MARK: - Init

    override init() {
        super.init()
        components.year = 2024
        components.month = 7
        components.day = 1 // 해당 월의 첫 번째 날을 설정
        if let targetDate = calendar.date(from: components) {
            outputs.days.onNext(generateCalendarDates(for: targetDate))
        }

        inputs.showSelectDate
            .bind(to: routes.dateBottomSheet)
            .disposed(by: disposeBag)
    }

    func generateCalendarDates(for date: Date) -> [MyLogStampConfig] {
        var dates: [MyLogStampConfig] = []

        // 오늘 날짜의 요일 계산 (1 = 일요일, 2 = 월요일, ..., 7 = 토요일)
        let startOfMonth = date.startOfMonth()
        let weekdayOfFirstDayInMonth = calendar.component(.weekday, from: startOfMonth)

        // 달력은 월요일부터 시작하므로 월요일이 첫 번째가 되도록 조정
        let adjustedWeekdayOfFirstDay = (weekdayOfFirstDayInMonth == 1) ? 7 : weekdayOfFirstDayInMonth - 1

        // 이전 달의 날짜 계산
        if adjustedWeekdayOfFirstDay > 1 {
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: date)!
            let rangeOfPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonth)!

            for i in stride(from: adjustedWeekdayOfFirstDay - 1, through: 1, by: -1) {
                let dayOfPreviousMonth = rangeOfPreviousMonth.count - i + 1
                let date = previousMonth.with(day: dayOfPreviousMonth)!
                let dayOfWeek = calendar.component(.weekday, from: date)
                let weekdayString = calendar.shortWeekdaySymbols[(dayOfWeek == 1) ? 6 : dayOfWeek - 2] // 요일 이름 가져오기
                dates.append(MyLogStampConfig(from: LogStamp(dayOfWeek: weekdayString, date: dayOfPreviousMonth)))
            }
        }

        // 이번 달의 날짜 추가
        let rangeOfCurrentMonth = calendar.range(of: .day, in: .month, for: date)!
        for day in rangeOfCurrentMonth {
            let date = startOfMonth.with(day: day)!
            let dayOfWeek = calendar.component(.weekday, from: date)
            let weekdayString = calendar.shortWeekdaySymbols[(dayOfWeek == 1) ? 6 : dayOfWeek - 2] // 월요일부터 시작하도록 조정
            dates.append(MyLogStampConfig(from: LogStamp(dayOfWeek: weekdayString, date: day)))
        }

        // 남은 칸을 다음 달의 날짜로 채우기
        let totalCells = 35
        if dates.count < totalCells {
            let remainingDays = totalCells - dates.count
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
            for day in 1 ... remainingDays {
                let date = nextMonth.with(day: day)!
                let dayOfWeek = calendar.component(.weekday, from: date)
                let weekdayString = calendar.shortWeekdaySymbols[(dayOfWeek == 1) ? 6 : dayOfWeek - 2]
                dates.append(MyLogStampConfig(from: LogStamp(dayOfWeek: weekdayString, date: day)))
            }
        }

        return dates
    }

    struct Input {
        var showSelectDate = PublishSubject<Void>()
    }

    struct Output {
        var days = ReplaySubject<[MyLogStampConfig]>.create(bufferSize: 1)
    }

    struct Route {
        var backward = PublishSubject<Void>()
        var dateBottomSheet = PublishSubject<Void>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
