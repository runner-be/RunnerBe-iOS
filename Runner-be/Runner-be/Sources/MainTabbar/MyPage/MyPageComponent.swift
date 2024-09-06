//
//  MyPageComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

final class MyPageComponent {
    lazy var scene: (VC: MyPageViewController, VM: MyPageViewModel) = (VC: MyPageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = MyPageViewModel()

    func calendarComponent() -> CalendarComponent {
        return CalendarComponent()
    }

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }

    func editInfoComponent(user: User) -> EditInfoComponent {
        return EditInfoComponent(user: user)
    }

    func settingsComponent(isOn: String) -> SettingsComponent {
        return SettingsComponent(isOn: isOn)
    }

    var writingPostComponent: WritingMainPostComponent {
        return WritingMainPostComponent()
    }

    var imageUploadService: ImageUploadService {
        return BasicImageUploadService()
    }

    var takePhotoModalComponent: TakePhotoModalComponent {
        return TakePhotoModalComponent()
    }

    func manageAttendanceComponent(myRunningIdx: Int) -> ManageAttendanceComponent {
        return ManageAttendanceComponent(myRunningIdx: myRunningIdx)
    }

    var registerRunningPaceComponent: RegisterRunningPaceComponent {
        return RegisterRunningPaceComponent()
    }

    var myRunningListComponent: MyRunningListComponent {
        return MyRunningListComponent()
    }

    func writeLogComponent(logForm: LogForm) -> WriteLogComponent {
        return WriteLogComponent(logForm: logForm)
    }

    func confirmLogComponent(postId: Int) -> ConfirmLogComponent {
        return ConfirmLogComponent(postId: postId)
    }

    func manageAttendanceComponent(postId: Int) -> ManageAttendanceComponent {
        return ManageAttendanceComponent(myRunningIdx: postId)
    }

    func confirmAttendanceComponent(postId: Int) -> ConfirmAttendanceComponent {
        return ConfirmAttendanceComponent(postId: postId)
    }
}
