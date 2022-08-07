

import Foundation
import NeedleFoundation

// swiftlint:disable unused_declaration
private let needleDependenciesHash: String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent") { component in
        EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent") { component in
        LoggedOutDependency2bcab0d3625f6f252479Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent->ReportModalComponent") { component in
        ReportModalDependencyb9c310c9766e66dc9083Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent->ReportModalComponent") { component in
        ReportModalDependency626f492cc98b0841b683Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent->ReportModalComponent") { component in
        ReportModalDependency7c1d923aae037ccbecd8Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MessageComponent->MessageChatComponent->ReportModalComponent") { component in
        ReportModalDependency7c87f66bcf84b474e31eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent->ApplicantListModalComponent") { component in
        ApplicantListModalDependency38daf10a5dd5609ffa27Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent->ApplicantListModalComponent") { component in
        ApplicantListModalDependency04cfed02b61183a240faProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent->ApplicantListModalComponent") { component in
        ApplicantListModalDependency369da0b8761222e1dadaProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent") { component in
        PostDetailDependency0e20bfa0f3e155bd15e3Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent") { component in
        PostDetailDependencyefc8ed9cd9a796bab512Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent") { component in
        PostDetailDependencyfaba91a453a4115aa8d1Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->WritingDetailPostComponent") { component in
        WritingDetailPostDependencybef9fe2df3caa6a55869Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent->WritingDetailPostComponent") { component in
        WritingDetailPostDependencyb2348cad5787e6e17e92Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectTimeModalComponent") { component in
        SelectTimeModalDependencyd8ded48eb82c59809282Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent->SelectTimeModalComponent") { component in
        SelectTimeModalDependency81aed5a40c91d94b031eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent") { component in
        WritingMainPostDependencyeba8c3d3228ba588faa8Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent") { component in
        WritingMainPostDependencya65ab5df0fc9f777cbeaProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectDateModalComponent") { component in
        SelectDateModalDependency547a4536ad6f1082ff72Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent->SelectDateModalComponent") { component in
        SelectDateModalDependency48c6d7ac20300654ff5cProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->HomeFilterComponent") { component in
        HomeFilterDependency4c2395ae43750f0e6394Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent") { component in
        HomeDependency69aec7ecd6b5263bd0e9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent") { component in
        MainTabDependency2826cdb310ed0b17a725Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent") { component in
        BookMarkDependency0c4e86716ba3aaf84ee1Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MessageComponent") { component in
        MessageDependencyb26316582fc24834a34cProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MessageComponent->MessageChatComponent") { component in
        MessageChatDependency69fa9a9e73666ac036deProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->LogoutModalComponent") { component in
        LogoutModalDependency198c1460728f9b03415bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent") { component in
        SettingsDependency70ef32136cd1f498fcc9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->MakerComponent") { component in
        MakerDependency5de256f346c664613971Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->SignoutModalComponent") { component in
        SignoutModalDependencyd6110434a325a5a129f2Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->SignoutCompletionModalComponent") { component in
        SignoutCompletionModalDependency0f8fb0dec6297ed4f8bfProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent->JobChangeModalComponent") { component in
        JobChangeModalDependency2bbe3c5431a3152c52a3Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent->NickNameChangeModalComponent") { component in
        NickNameChangeModalDependencyb35b5747f04ee5549ecdProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent") { component in
        EditInfoDependency226a6a95833dbef9e88dProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent") { component in
        MyPageDependencyed3a2dbc57f299854a2fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->TakePhotoModalComponent") { component in
        TakePhotoModalDependency5e33043fb398e1a3f039Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->ManageAttendanceComponent") { component in
        ManageAttendanceDependency5959a5f846d942c93b1eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent") { component in
        OnboardingCoverDependency6c57a78c75f1d24e9771Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent") { component in
        BirthDependencyc713361cb899f136292eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent") { component in
        SelectJobGroupDependencyc9eb1582ec9eed779e29Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent") { component in
        PolicyTermDependency8a9f3fef79c1be8bd4c0Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->PolicyDetailComponent") { component in
        PolicyDetailDependencyf1b0f14079b572bc52b9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->PolicyDetailComponent") { component in
        PolicyDetailDependencye1217a8d1cdad9937ef3Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent") { component in
        SelectGenderDependency735326173f42f19f32b1Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->OnboardingCancelModalComponent") { component in
        OnboardingCancelModalDependencyb0d82bb064f08221e5feProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->OnboardingCancelModalComponent") { component in
        OnboardingCancelModalDependencyc09dddbe6d1d243f2e4bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->OnboardingCancelModalComponent") { component in
        OnboardingCancelModalDependency3b8e24242190b29ad71eProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->OnboardingCancelModalComponent") { component in
        OnboardingCancelModalDependency6ea49e4ded466cff2a93Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->OnboardingCompletionComponent") { component in
        OnboardingCompletionDependency1de7c4072dce0d49e566Provider(component: component)
    }
}

// MARK: - Providers

private class LoggedOutDependency2bcab0d3625f6f252479BaseProvider: LoggedOutDependency {
    init() {}
}

/// ^->AppComponent->LoggedOutComponent
private class LoggedOutDependency2bcab0d3625f6f252479Provider: LoggedOutDependency2bcab0d3625f6f252479BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class ReportModalDependencyb9c310c9766e66dc9083BaseProvider: ReportModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent->ReportModalComponent
private class ReportModalDependencyb9c310c9766e66dc9083Provider: ReportModalDependencyb9c310c9766e66dc9083BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent->ReportModalComponent
private class ReportModalDependency626f492cc98b0841b683Provider: ReportModalDependencyb9c310c9766e66dc9083BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent->ReportModalComponent
private class ReportModalDependency7c1d923aae037ccbecd8Provider: ReportModalDependencyb9c310c9766e66dc9083BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MessageComponent->MessageChatComponent->ReportModalComponent
private class ReportModalDependency7c87f66bcf84b474e31eProvider: ReportModalDependencyb9c310c9766e66dc9083BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class ApplicantListModalDependency38daf10a5dd5609ffa27BaseProvider: ApplicantListModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent->ApplicantListModalComponent
private class ApplicantListModalDependency38daf10a5dd5609ffa27Provider: ApplicantListModalDependency38daf10a5dd5609ffa27BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent->ApplicantListModalComponent
private class ApplicantListModalDependency04cfed02b61183a240faProvider: ApplicantListModalDependency38daf10a5dd5609ffa27BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent->ApplicantListModalComponent
private class ApplicantListModalDependency369da0b8761222e1dadaProvider: ApplicantListModalDependency38daf10a5dd5609ffa27BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class PostDetailDependency0e20bfa0f3e155bd15e3BaseProvider: PostDetailDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent
private class PostDetailDependency0e20bfa0f3e155bd15e3Provider: PostDetailDependency0e20bfa0f3e155bd15e3BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent
private class PostDetailDependencyefc8ed9cd9a796bab512Provider: PostDetailDependency0e20bfa0f3e155bd15e3BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent
private class PostDetailDependencyfaba91a453a4115aa8d1Provider: PostDetailDependency0e20bfa0f3e155bd15e3BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class WritingDetailPostDependencybef9fe2df3caa6a55869BaseProvider: WritingDetailPostDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->WritingDetailPostComponent
private class WritingDetailPostDependencybef9fe2df3caa6a55869Provider: WritingDetailPostDependencybef9fe2df3caa6a55869BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent->WritingDetailPostComponent
private class WritingDetailPostDependencyb2348cad5787e6e17e92Provider: WritingDetailPostDependencybef9fe2df3caa6a55869BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SelectTimeModalDependencyd8ded48eb82c59809282BaseProvider: SelectTimeModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectTimeModalComponent
private class SelectTimeModalDependencyd8ded48eb82c59809282Provider: SelectTimeModalDependencyd8ded48eb82c59809282BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent->SelectTimeModalComponent
private class SelectTimeModalDependency81aed5a40c91d94b031eProvider: SelectTimeModalDependencyd8ded48eb82c59809282BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class WritingMainPostDependencyeba8c3d3228ba588faa8BaseProvider: WritingMainPostDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent
private class WritingMainPostDependencyeba8c3d3228ba588faa8Provider: WritingMainPostDependencyeba8c3d3228ba588faa8BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent
private class WritingMainPostDependencya65ab5df0fc9f777cbeaProvider: WritingMainPostDependencyeba8c3d3228ba588faa8BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SelectDateModalDependency547a4536ad6f1082ff72BaseProvider: SelectDateModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectDateModalComponent
private class SelectDateModalDependency547a4536ad6f1082ff72Provider: SelectDateModalDependency547a4536ad6f1082ff72BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->WritingMainPostComponent->SelectDateModalComponent
private class SelectDateModalDependency48c6d7ac20300654ff5cProvider: SelectDateModalDependency547a4536ad6f1082ff72BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class HomeFilterDependency4c2395ae43750f0e6394BaseProvider: HomeFilterDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent->HomeFilterComponent
private class HomeFilterDependency4c2395ae43750f0e6394Provider: HomeFilterDependency4c2395ae43750f0e6394BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class HomeDependency69aec7ecd6b5263bd0e9BaseProvider: HomeDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->HomeComponent
private class HomeDependency69aec7ecd6b5263bd0e9Provider: HomeDependency69aec7ecd6b5263bd0e9BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class MainTabDependency2826cdb310ed0b17a725BaseProvider: MainTabDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent
private class MainTabDependency2826cdb310ed0b17a725Provider: MainTabDependency2826cdb310ed0b17a725BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class BookMarkDependency0c4e86716ba3aaf84ee1BaseProvider: BookMarkDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->BookMarkComponent
private class BookMarkDependency0c4e86716ba3aaf84ee1Provider: BookMarkDependency0c4e86716ba3aaf84ee1BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class MessageDependencyb26316582fc24834a34cBaseProvider: MessageDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MessageComponent
private class MessageDependencyb26316582fc24834a34cProvider: MessageDependencyb26316582fc24834a34cBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class MessageChatDependency69fa9a9e73666ac036deBaseProvider: MessageChatDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MessageComponent->MessageChatComponent
private class MessageChatDependency69fa9a9e73666ac036deProvider: MessageChatDependency69fa9a9e73666ac036deBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class LogoutModalDependency198c1460728f9b03415bBaseProvider: LogoutModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->LogoutModalComponent
private class LogoutModalDependency198c1460728f9b03415bProvider: LogoutModalDependency198c1460728f9b03415bBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SettingsDependency70ef32136cd1f498fcc9BaseProvider: SettingsDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent
private class SettingsDependency70ef32136cd1f498fcc9Provider: SettingsDependency70ef32136cd1f498fcc9BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class MakerDependency5de256f346c664613971BaseProvider: MakerDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->MakerComponent
private class MakerDependency5de256f346c664613971Provider: MakerDependency5de256f346c664613971BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SignoutModalDependencyd6110434a325a5a129f2BaseProvider: SignoutModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->SignoutModalComponent
private class SignoutModalDependencyd6110434a325a5a129f2Provider: SignoutModalDependencyd6110434a325a5a129f2BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SignoutCompletionModalDependency0f8fb0dec6297ed4f8bfBaseProvider: SignoutCompletionModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->SignoutCompletionModalComponent
private class SignoutCompletionModalDependency0f8fb0dec6297ed4f8bfProvider: SignoutCompletionModalDependency0f8fb0dec6297ed4f8bfBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class JobChangeModalDependency2bbe3c5431a3152c52a3BaseProvider: JobChangeModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent->JobChangeModalComponent
private class JobChangeModalDependency2bbe3c5431a3152c52a3Provider: JobChangeModalDependency2bbe3c5431a3152c52a3BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class NickNameChangeModalDependencyb35b5747f04ee5549ecdBaseProvider: NickNameChangeModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent->NickNameChangeModalComponent
private class NickNameChangeModalDependencyb35b5747f04ee5549ecdProvider: NickNameChangeModalDependencyb35b5747f04ee5549ecdBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class EditInfoDependency226a6a95833dbef9e88dBaseProvider: EditInfoDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent
private class EditInfoDependency226a6a95833dbef9e88dProvider: EditInfoDependency226a6a95833dbef9e88dBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class MyPageDependencyed3a2dbc57f299854a2fBaseProvider: MyPageDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent
private class MyPageDependencyed3a2dbc57f299854a2fProvider: MyPageDependencyed3a2dbc57f299854a2fBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class TakePhotoModalDependency5e33043fb398e1a3f039BaseProvider: TakePhotoModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->TakePhotoModalComponent
private class TakePhotoModalDependency5e33043fb398e1a3f039Provider: TakePhotoModalDependency5e33043fb398e1a3f039BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class ManageAttendanceDependency5959a5f846d942c93b1eBaseProvider: ManageAttendanceDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->ManageAttendanceComponent
private class ManageAttendanceDependency5959a5f846d942c93b1eProvider: ManageAttendanceDependency5959a5f846d942c93b1eBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class OnboardingCoverDependency6c57a78c75f1d24e9771BaseProvider: OnboardingCoverDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent
private class OnboardingCoverDependency6c57a78c75f1d24e9771Provider: OnboardingCoverDependency6c57a78c75f1d24e9771BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class BirthDependencyc713361cb899f136292eBaseProvider: BirthDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent
private class BirthDependencyc713361cb899f136292eProvider: BirthDependencyc713361cb899f136292eBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SelectJobGroupDependencyc9eb1582ec9eed779e29BaseProvider: SelectJobGroupDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent
private class SelectJobGroupDependencyc9eb1582ec9eed779e29Provider: SelectJobGroupDependencyc9eb1582ec9eed779e29BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class PolicyTermDependency8a9f3fef79c1be8bd4c0BaseProvider: PolicyTermDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent
private class PolicyTermDependency8a9f3fef79c1be8bd4c0Provider: PolicyTermDependency8a9f3fef79c1be8bd4c0BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class PolicyDetailDependencyf1b0f14079b572bc52b9BaseProvider: PolicyDetailDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent->PolicyDetailComponent
private class PolicyDetailDependencyf1b0f14079b572bc52b9Provider: PolicyDetailDependencyf1b0f14079b572bc52b9BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->PolicyDetailComponent
private class PolicyDetailDependencye1217a8d1cdad9937ef3Provider: PolicyDetailDependencyf1b0f14079b572bc52b9BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class SelectGenderDependency735326173f42f19f32b1BaseProvider: SelectGenderDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent
private class SelectGenderDependency735326173f42f19f32b1Provider: SelectGenderDependency735326173f42f19f32b1BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class OnboardingCancelModalDependencyb0d82bb064f08221e5feBaseProvider: OnboardingCancelModalDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependencyb0d82bb064f08221e5feProvider: OnboardingCancelModalDependencyb0d82bb064f08221e5feBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependencyc09dddbe6d1d243f2e4bProvider: OnboardingCancelModalDependencyb0d82bb064f08221e5feBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependency3b8e24242190b29ad71eProvider: OnboardingCancelModalDependencyb0d82bb064f08221e5feBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependency6ea49e4ded466cff2a93Provider: OnboardingCancelModalDependencyb0d82bb064f08221e5feBaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}

private class OnboardingCompletionDependency1de7c4072dce0d49e566BaseProvider: OnboardingCompletionDependency {
    init() {}
}

/// ^->AppComponent->MainTabComponent->OnboardingCoverComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->OnboardingCompletionComponent
private class OnboardingCompletionDependency1de7c4072dce0d49e566Provider: OnboardingCompletionDependency1de7c4072dce0d49e566BaseProvider {
    init(component _: NeedleFoundation.Scope) {
        super.init()
    }
}
