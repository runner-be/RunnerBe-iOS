//
//  2__3_MyPageComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import UIKit

final class MyPageComponent {
    lazy var scene: (VC: MyPageViewController, VM: MyPageViewModel) = (VC: MyPageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = MyPageViewModel()

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(postId: postId)
    }

    func editInfoComponent(user: User) -> EditInfoComponent {
        return EditInfoComponent(user: user)
    }

    var settingsComponent: SettingsComponent {
        return SettingsComponent()
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
}
