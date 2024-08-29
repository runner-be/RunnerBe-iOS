//
//  SelectDateBottomSheetViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import Foundation
import RxSwift

enum RunningLogStatus {
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
        case .FUTURE:
            return nil
        }
    }
}

final class SelectDateBottomSheetViewModel: BaseViewModel {
    init(year _: Int, month: Int) {
        super.init()

        inputs.yearSelected = 0
        inputs.monthSelected = outputs.monthItems.map { item in
            Int(item.replacingOccurrences(of: "월", with: "")) ?? 0
        }.firstIndex(of: month) ?? 0

        inputs.selectDate
            .map { [weak self] _ in
                guard let yearIndex = self?.inputs.yearSelected,
                      let monthIndex = self?.inputs.monthSelected,
                      let yearItem = self?.outputs.yearItems[yearIndex],
                      let year = Int(yearItem)
                else { return nil }

                return (year: year,
                        month: monthIndex + 1)
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
        var yearItems: [String] = ["2024"]
        var monthItems: [String] = ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"]
    }

    struct Route {
        var cancel = PublishSubject<Void>()
        var apply = PublishSubject<(year: Int, month: Int)?>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
}
