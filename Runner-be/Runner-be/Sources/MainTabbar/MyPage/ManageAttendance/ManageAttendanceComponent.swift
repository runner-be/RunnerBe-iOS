//
//  ManageAttendanceComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import Foundation
import NeedleFoundation

protocol ManageAttendanceDependency: Dependency {}

final class ManageAttendanceComponent:
    Component<ManageAttendanceDependency>
{
    var scene: (VC: UIViewController, VM: ManageAttendanceViewModel) {
        let viewModel = self.viewModel
        return (ManageAttendanceViewController(viewModel: viewModel, myRunningIdx: myRunningIdx), viewModel)
    }

    var viewModel: ManageAttendanceViewModel {
        return ManageAttendanceViewModel(myRunningIdx: myRunningIdx)
    }

    let myRunningIdx: Int

    /* component 생성시 추가 정보가 필요하다면 다음처럼 init을 구현해주시면 됩니다. */
    init(parent: Scope, myRunningIdx: Int) {
        self.myRunningIdx = myRunningIdx
        super.init(parent: parent)
    }

    var manageExpiredModalComponent: ManageTimeExpiredModalComponent {
        return ManageTimeExpiredModalComponent(parent: self)
    }
}