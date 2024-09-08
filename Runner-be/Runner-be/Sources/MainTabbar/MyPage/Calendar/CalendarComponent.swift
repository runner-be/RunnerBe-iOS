//
//  CalendarComponent.swift
//  Runner-be
//
//  Created by 김창규 on 8/27/24.
//

import UIKit

final class CalendarComponent {
    var scene: (VC: UIViewController, VM: CalendarViewModel) {
        let viewModel = self.viewModel
        return (CalendarViewController(viewModel: viewModel), viewModel)
    }

    lazy var viewModel = CalendarViewModel()

    func selectDateComponent(selectedDate: Date) -> SelectDateBottomSheetComponent {
        return SelectDateBottomSheetComponent(selectedDate: selectedDate)
    }
}
