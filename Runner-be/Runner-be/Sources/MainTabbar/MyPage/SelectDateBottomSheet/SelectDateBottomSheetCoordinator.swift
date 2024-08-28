//
//  SelectDateBottomSheetCoordinator.swift
//  Runner-be
//
//  Created by 김창규 on 8/28/24.
//

import UIKit

enum SelectDateBottomSheetResult {
    case apply(year: Int, month: Int)
    case cancel
}

final class SelectDateBottomSheetCoordinator: BasicCoordinator<SelectDateBottomSheetResult> {
    var component: SelectDateBottomSheetComponent

    init(
        component: SelectDateBottomSheetComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated: Bool = true) {
        let scene = component.scene
        scene.VC.modalPresentationStyle = .overCurrentContext
        navigationController.present(scene.VC, animated: animated)

        closeSignal
            .subscribe(onNext: { result in
                switch result {
                case let .apply(year, month):
                    scene.VC.dismiss(animated: false)
                case .cancel:
                    scene.VC.dismiss(animated: false)
                }
            }).disposed(by: sceneDisposeBag)

        scene.VM.routes.cancel
            .map { SelectDateBottomSheetResult.cancel }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)

        scene.VM.routes.apply
            .map { selectedDate -> SelectDateBottomSheetResult in
                guard let selectedDate = selectedDate else {
                    return .apply(year: 0, month: 0)
                }
                return .apply(
                    year: selectedDate.year,
                    month: selectedDate.month
                )
            }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
    }
}
