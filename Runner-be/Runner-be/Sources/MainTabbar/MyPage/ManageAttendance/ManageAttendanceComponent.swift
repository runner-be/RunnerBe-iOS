//
//  ManageAttendanceComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import NeedleFoundation

protocol ManageAttendanceDependency: Dependency {}

final class ManageAttendanceComponent: Component<ManageAttendanceDependency> {
    var scene: (VC: UIViewController, VM: ManageAttendanceViewModel) {
        let viewModel = self.viewModel
        return (ManageAttendanceViewController(viewModel: viewModel), viewModel)
    }

    private var viewModel: ManageAttendanceViewModel {
        return ManageAttendanceViewModel()
    }
}
