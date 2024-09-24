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
        return ConfirmLogViewModel(logForm: logForm)
    }

    var logForm: LogForm

    init(logForm: LogForm) {
        self.logForm = logForm
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
}
