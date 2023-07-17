//
//  ManageAttendanceComponent.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/04.
//

import UIKit

final class ManageAttendanceComponent {
    var scene: (VC: UIViewController, VM: ManageAttendanceViewModel) {
        let viewModel = self.viewModel
        return (ManageAttendanceViewController(viewModel: viewModel, myRunningIdx: myRunningIdx), viewModel)
    }

    var viewModel: ManageAttendanceViewModel {
        return ManageAttendanceViewModel(myRunningIdx: myRunningIdx)
    }

    let myRunningIdx: Int

    init(myRunningIdx: Int) {
        self.myRunningIdx = myRunningIdx
    }

    var manageExpiredModalComponent: ManageTimeExpiredModalComponent {
        return ManageTimeExpiredModalComponent()
    }

    var myPageComponent: MyPageComponent {
        return MyPageComponent()
    }
}
