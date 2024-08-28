//
//  SelectDateBottomSheetViewModel.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import Foundation
import RxSwift

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
