//
//  2__3_MyPageComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MyPageDependency: Dependency {}

final class MyPageComponent: Component<MyPageDependency> {
    var sharedScene: (VC: MyPageViewController, VM: MyPageViewModel) {
        return shared {
            let viewModel = viewModel
            return (VC: MyPageViewController(viewModel: viewModel), VM: viewModel)
        }
    }

    var viewModel: MyPageViewModel {
        return MyPageViewModel()
    }
}
