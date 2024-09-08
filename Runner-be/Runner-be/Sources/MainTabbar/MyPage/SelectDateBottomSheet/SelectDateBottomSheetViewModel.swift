//
//  SelectDateBottomSheetViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import Foundation
import RxSwift

enum StampType: String, Equatable {
    case RUN001 // 체크
    case RUN002 // 성취
    case RUN003 // 사교
    case RUN004 // 지속
    case RUN005 // 흥미
    case RUN006 // 성장
    case RUN007 // 독기
    case RUN008 // 감성
    case RUN009 // 쾌락
    case RUN010 // 질주
    case WEA001 // 맑음
    case WEA002 // 흐림
    case WEA003 // 야간
    case WEA004 // 비
    case WEA005 // 눈
    case FUTURE // 미래(아이콘 없이 숫자만 표시합니다.)

    var icon: UIImage? {
        switch self {
        case .RUN001:
            return Asset.runningLogRUN001.uiImage
        case .RUN002:
            return Asset.runningLogRUN002.uiImage
        case .RUN003:
            return Asset.runningLogRUN003.uiImage
        case .RUN004:
            return Asset.runningLogRUN004.uiImage
        case .RUN005:
            return Asset.runningLogRUN005.uiImage
        case .RUN006:
            return Asset.runningLogRUN006.uiImage
        case .RUN007:
            return Asset.runningLogRUN007.uiImage
        case .RUN008:
            return Asset.runningLogRUN008.uiImage
        case .RUN009:
            return Asset.runningLogRUN009.uiImage
        case .RUN010:
            return Asset.runningLogRUN010.uiImage
        case .WEA001:
            return Asset.runningWeatherSunny.uiImage
        case .WEA002:
            return Asset.runningWeatherCloudy.uiImage
        case .WEA003:
            return Asset.runningWeatherNight.uiImage
        case .WEA004:
            return Asset.runningWeatherRainy.uiImage
        case .WEA005:
            return Asset.runningWeatherSnowy.uiImage
        case .FUTURE:
            return nil
        }
    }

    var title: String {
        switch self {
        case .RUN001:
            return "Check!"
        case .RUN002:
            return "성취"
        case .RUN003:
            return "사교"
        case .RUN004:
            return "지속"
        case .RUN005:
            return "흥미"
        case .RUN006:
            return "성장"
        case .RUN007:
            return "독기"
        case .RUN008:
            return "감성"
        case .RUN009:
            return "쾌락"
        case .RUN010:
            return "질주"
        case .WEA001:
            return "맑음"
        case .WEA002:
            return "흐림"
        case .WEA003:
            return "야간"
        case .WEA004:
            return "비"
        case .WEA005:
            return "눈"
        case .FUTURE:
            return ""
        }
    }

    var subTitle: String {
        switch self {
        case .RUN001:
            return "체크메이트~ 오늘도 해냈군요!"
        case .RUN002:
            return "달리며 뿌듯하게 자랑할 만한 일이 일어났어요!"
        case .RUN003:
            return "달리기를 통해 소통하며 친구를 만들었어요!"
        case .RUN004:
            return "게으름 피우지 않고 꾸준히 달렸어요!"
        case .RUN005:
            return "풍경, 이벤트 등 달리는 도중 다양한 일들이 생겼어요!"
        case .RUN006:
            return "달리는 도중 이전보다 한층 더 성장한 나를 발견했어요!"
        case .RUN007:
            return "힘들어도 멈추지 않고 끝까지 달렸어요!"
        case .RUN008:
            return "이 온도, 이 습도, 이 러닝... 모든 게 아름다운 달리기였어요!"
        case .RUN009:
            return "달리는 도중 심장이 터지도록 즐거움을 느꼈어요!"
        case .RUN010:
            return "속도를 내며 누구보다 빠르게 달린 날이에요!"
        case .FUTURE, .WEA001, .WEA002, .WEA003, .WEA004, .WEA005:
            return ""
        }
    }
}

final class SelectDateBottomSheetViewModel: BaseViewModel {
    // MARK: - Properties

    private var targetDate: Date

    var targetYear: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: targetDate)
        return Int(yearString) ?? 0000
    }

    var targetMonth: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: targetDate)
        return Int(monthString) ?? 00
    }

    // MARK: - Init

    init(selectedDate: Date) {
        targetDate = selectedDate
        super.init()

        outputs = Output(
            yearItems: Array(2024 ... targetYear),
            monthItems: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].filter {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM"
                let monthString = formatter.string(from: Date())
                let monthInt = Int(monthString) ?? 00
                return $0 <= monthInt
            }
        )

        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: selectedDate)
        inputs.yearSelected = 0
        inputs.monthSelected = outputs.monthItems.firstIndex(of: targetMonth) ?? 0
        inputs.selectDate
            .compactMap { [weak self] _ in
                guard let yearIndex = self?.inputs.yearSelected,
                      let monthIndex = self?.inputs.monthSelected,
                      let year = self?.outputs.yearItems[yearIndex]
                else { return nil }

                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = monthIndex + 1 // monthIndex는 0 기반이므로 1을 더해줌
                dateComponents.day = 1 // 필요에 따라 기본 일(day)을 설정

                // Calendar를 사용하여 Date로 변환
                let calendar = Calendar.current
                if let date = calendar.date(from: dateComponents) {
                    return date
                }

                return nil
            }
            .bind(to: routes.apply)
            .disposed(by: disposeBag)
    }

    struct Input {
        var yearSelected: Int = 0
        var monthSelected: Int = 0
        var selectDate = PublishSubject<Void>()
    }

    struct Output {
        var yearItems: [Int] = []
        var monthItems: [Int] = []
    }

    struct Route {
        var cancel = PublishSubject<Void>()
        var apply = PublishSubject<Date>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
