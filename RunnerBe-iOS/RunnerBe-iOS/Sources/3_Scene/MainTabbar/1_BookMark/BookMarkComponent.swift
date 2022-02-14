//
//  2__1BookMarkComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol BookMarkDependency: Dependency {}

final class BookMarkComponent: Component<BookMarkDependency> {
    var scene: (VC: BookMarkViewController, VM: BookMarkViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: BookMarkViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    var viewModel: BookMarkViewModel {
        return BookMarkViewModel()
    }
}
