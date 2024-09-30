//
//  ConfirmLogComponent.swift
//  Runner-be
//
//  Created by 김창규 on 8/30/24.
//

import Foundation

final class ConfirmLogComponent {
    var scene: (VC: ConfirmLogViewController, VM: ConfirmLogViewModel) {
        let viewModel = self.viewModel
        return (VC: ConfirmLogViewController(viewModel: viewModel), VM: viewModel)
    }

    var viewModel: ConfirmLogViewModel {
        return ConfirmLogViewModel(logId: logId)
    }

    var logId: Int

    init(logId: Int) {
        self.logId = logId
    }

    var menuModalComponent: MenuModalComponent {
        return MenuModalComponent()
    }

    func writeLogComponent(
        logForm: LogForm,
        writeLogMode: WriteLogMode
    ) -> WriteLogComponent {
        return WriteLogComponent(
            logForm: logForm,
            writeLogMode: writeLogMode
        )
    }

    func newConfirmLogComponent(logId: Int) -> ConfirmLogComponent {
        return ConfirmLogComponent(logId: logId)
    }

    var togetherRunnerComponent: TogetherRunnerComponent {
        return TogetherRunnerComponent()
    }
}
