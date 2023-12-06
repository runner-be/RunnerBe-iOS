//
//  HomeComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

final class HomeComponent {
    lazy var scene: (VC: HomeViewController, VM: HomeViewModel) = (VC: HomeViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel: HomeViewModel = .init()

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }

    var writingPostComponent: WritingMainPostComponent {
        return WritingMainPostComponent()
    }

    func postFilterComponent(filter: PostFilter) -> HomeFilterComponent {
        return HomeFilterComponent(filter: filter)
    }

    func postListOrderModal() -> PostOrderModalComponent {
        return PostOrderModalComponent()
    }

    func runningTagModal() -> RunningTagModalComponent {
        return RunningTagModalComponent()
    }

    var alarmListComponent: AlarmListComponent {
        return AlarmListComponent()
    }
}
