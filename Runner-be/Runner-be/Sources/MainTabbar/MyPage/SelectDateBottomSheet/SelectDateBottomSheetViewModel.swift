//
//  SelectDateBottomSheetViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import Foundation
import RxSwift

enum RunningLogStatus: String {
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
        case .FUTURE:
            return ""
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
