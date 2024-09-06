//
//  LogModalComponent.swift
//  Runner-be
//
//  Created by 김창규 on 9/6/24.
//

import Foundation

import UIKit

final class LogModalComponent {
    var scene: (VC: UIViewController, VM: LogModalViewModel) {
        let viewModel = self.viewModel
        return (LogModalViewController(viewModel: viewModel), viewModel)
    }

    var viewModel: LogModalViewModel {
        return LogModalViewModel()
    }
}
