//
//  2__3_MyPageComponent.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//

import Foundation
import NeedleFoundation

protocol MyPageDependency: Dependency {}

final class MyPageComponent: Component<MyPageDependency> {
    lazy var scene: (VC: MyPageViewController, VM: MyPageViewModel) = (VC: MyPageViewController(viewModel: viewModel), VM: viewModel)

    lazy var viewModel = MyPageViewModel()

    func postDetailComponent(postId: Int) -> PostDetailComponent {
        return PostDetailComponent(parent: self, postId: postId)
    }

    func editInfoComponent(user: User) -> EditInfoComponent {
        return EditInfoComponent(parent: self, user: user)
    }

    var settingsComponent: SettingsComponent {
        return SettingsComponent(parent: self)
    }

    var writingPostComponent: WritingMainPostComponent {
        return WritingMainPostComponent(parent: self)
    }

    var imageUploadService: ImageUploadService {
        return BasicImageUploadService()
    }

    var takePhotoModalComponent: TakePhotoModalComponent {
        return TakePhotoModalComponent(parent: self)
    }

    func manageAttendanceComponent(myRunningIdx: Int) -> ManageAttendanceComponent {
        return ManageAttendanceComponent(parent: self, myRunningIdx: myRunningIdx)
    }
}
