//
//  WritingPostComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/18.
//

import UIKit

final class WritingMainPostComponent {
    var scene: (VC: UIViewController, VM: WritingMainPostViewModel) {
        let viewModel = self.viewModel
        return (WritingMainPostViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: WritingMainPostViewModel {
        return WritingMainPostViewModel()
    }

    func selectTimeComponent(timeString: String) -> SelectTimeModalComponent {
        return SelectTimeModalComponent(timeString: timeString)
    }

    func selectDateComponent(dateInterval: Double) -> SelectDateModalComponent {
        return SelectDateModalComponent(dateInterval: dateInterval)
    }

    func BuildWritingDetailPostComponent(with data: WritingPostData) -> WritingDetailPostComponent {
        return WritingDetailPostComponent(writingPostData: data)
    }
}
