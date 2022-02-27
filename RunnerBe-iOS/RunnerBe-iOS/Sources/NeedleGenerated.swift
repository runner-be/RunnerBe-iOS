

import Foundation
import NeedleFoundation

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent") { component in
        return LoggedOutDependency2bcab0d3625f6f252479Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent") { component in
        return MainTabDependency2826cdb310ed0b17a725Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent") { component in
        return BookMarkDependency0c4e86716ba3aaf84ee1Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent") { component in
        return SettingsDependency70ef32136cd1f498fcc9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent") { component in
        return EditInfoDependency226a6a95833dbef9e88dProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent") { component in
        return MyPageDependencyed3a2dbc57f299854a2fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->WritingDetailPostComponent") { component in
        return WritingDetailPostDependencybef9fe2df3caa6a55869Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectTimeModalComponent") { component in
        return SelectTimeModalDependencyd8ded48eb82c59809282Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent") { component in
        return WritingMainPostDependencyeba8c3d3228ba588faa8Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectDateModalComponent") { component in
        return SelectDateModalDependency547a4536ad6f1082ff72Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent->ApplicantListModalComponent") { component in
        return ApplicantListModalDependency04cfed02b61183a240faProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent->ApplicantListModalComponent") { component in
        return ApplicantListModalDependency369da0b8761222e1dadaProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent->ApplicantListModalComponent") { component in
        return ApplicantListModalDependency38daf10a5dd5609ffa27Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent") { component in
        return PostDetailDependencyefc8ed9cd9a796bab512Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent") { component in
        return PostDetailDependencyfaba91a453a4115aa8d1Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent") { component in
        return PostDetailDependency0e20bfa0f3e155bd15e3Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent->HomeFilterComponent") { component in
        return HomeFilterDependency4c2395ae43750f0e6394Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent") { component in
        return HomeDependency69aec7ecd6b5263bd0e9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent") { component in
        return PolicyTermDependency28006fce607070d6ca75Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->PolicyDetailComponent") { component in
        return PolicyDetailDependencyab7a37b72bd8b136a461Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent->WaitCertificationComponent") { component in
        return WaitCertificationDependencya59e7f4494bb58452d1aProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->OnboardingCompletionComponent") { component in
        return OnboardingCompletionDependencyfab662889368f161b644Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent") { component in
        return PhotoCertificationDependency919976e3bbe7c6970accProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent->PhotoModalComponent") { component in
        return PhotoModalDependency256710ef3f831e315f20Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent") { component in
        return EmailCertificationDependencyf5f9a83429ebc20c0ea9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->EmailCertificationInitModalComponent") { component in
        return EmailCertificationInitModalDependencyc0fcd95426abdc2eb784Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent") { component in
        return BirthDependencyeacd7a6dc893684c63a8Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->OnboardingCancelModalComponent") { component in
        return OnboardingCancelModalDependency163a186c00ad3225b79bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent->OnboardingCancelModalComponent") { component in
        return OnboardingCancelModalDependency680f661d1573dc6db5cbProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->OnboardingCancelModalComponent") { component in
        return OnboardingCancelModalDependency41086b612da017603ac7Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->OnboardingCancelModalComponent") { component in
        return OnboardingCancelModalDependencyd5d244529412faa64d91Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->OnboardingCancelModalComponent") { component in
        return OnboardingCancelModalDependencycb42558bc283046b72a5Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->OnboardingCancelModalComponent") { component in
        return OnboardingCancelModalDependency07be119931b373c0743bProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent") { component in
        return SelectJobGroupDependency2420d5f31bd0022c257fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent") { component in
        return SelectGenderDependency1501a6b74f78c8951e52Provider(component: component)
    }
    
}

// MARK: - Providers

private class LoggedOutDependency2bcab0d3625f6f252479BaseProvider: LoggedOutDependency {
    var loginService: LoginService {
        return appComponent.loginService
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->LoggedOutComponent
private class LoggedOutDependency2bcab0d3625f6f252479Provider: LoggedOutDependency2bcab0d3625f6f252479BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent as! AppComponent)
    }
}
private class MainTabDependency2826cdb310ed0b17a725BaseProvider: MainTabDependency {
    var dateService: DateService {
        return appComponent.dateService
    }
    var loginService: LoginService {
        return appComponent.loginService
    }
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainTabComponent
private class MainTabDependency2826cdb310ed0b17a725Provider: MainTabDependency2826cdb310ed0b17a725BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent as! AppComponent)
    }
}
private class BookMarkDependency0c4e86716ba3aaf84ee1BaseProvider: BookMarkDependency {
    var postAPIService: PostAPIService {
        return mainTabComponent.postAPIService
    }
    private let mainTabComponent: MainTabComponent
    init(mainTabComponent: MainTabComponent) {
        self.mainTabComponent = mainTabComponent
    }
}
/// ^->AppComponent->MainTabComponent->BookMarkComponent
private class BookMarkDependency0c4e86716ba3aaf84ee1Provider: BookMarkDependency0c4e86716ba3aaf84ee1BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent as! MainTabComponent)
    }
}
private class SettingsDependency70ef32136cd1f498fcc9BaseProvider: SettingsDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->MyPageComponent->SettingsComponent
private class SettingsDependency70ef32136cd1f498fcc9Provider: SettingsDependency70ef32136cd1f498fcc9BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class EditInfoDependency226a6a95833dbef9e88dBaseProvider: EditInfoDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->MyPageComponent->EditInfoComponent
private class EditInfoDependency226a6a95833dbef9e88dProvider: EditInfoDependency226a6a95833dbef9e88dBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class MyPageDependencyed3a2dbc57f299854a2fBaseProvider: MyPageDependency {
    var postAPIService: PostAPIService {
        return mainTabComponent.postAPIService
    }
    var dateService: DateService {
        return appComponent.dateService
    }
    private let appComponent: AppComponent
    private let mainTabComponent: MainTabComponent
    init(appComponent: AppComponent, mainTabComponent: MainTabComponent) {
        self.appComponent = appComponent
        self.mainTabComponent = mainTabComponent
    }
}
/// ^->AppComponent->MainTabComponent->MyPageComponent
private class MyPageDependencyed3a2dbc57f299854a2fProvider: MyPageDependencyed3a2dbc57f299854a2fBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent as! AppComponent, mainTabComponent: component.parent as! MainTabComponent)
    }
}
private class WritingDetailPostDependencybef9fe2df3caa6a55869BaseProvider: WritingDetailPostDependency {
    var postAPIService: PostAPIService {
        return mainTabComponent.postAPIService
    }
    var dateService: DateService {
        return appComponent.dateService
    }
    var loginService: LoginService {
        return appComponent.loginService
    }
    private let appComponent: AppComponent
    private let mainTabComponent: MainTabComponent
    init(appComponent: AppComponent, mainTabComponent: MainTabComponent) {
        self.appComponent = appComponent
        self.mainTabComponent = mainTabComponent
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->WritingDetailPostComponent
private class WritingDetailPostDependencybef9fe2df3caa6a55869Provider: WritingDetailPostDependencybef9fe2df3caa6a55869BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent.parent as! AppComponent, mainTabComponent: component.parent.parent.parent as! MainTabComponent)
    }
}
private class SelectTimeModalDependencyd8ded48eb82c59809282BaseProvider: SelectTimeModalDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectTimeModalComponent
private class SelectTimeModalDependencyd8ded48eb82c59809282Provider: SelectTimeModalDependencyd8ded48eb82c59809282BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class WritingMainPostDependencyeba8c3d3228ba588faa8BaseProvider: WritingMainPostDependency {
    var locationService: LocationService {
        return homeComponent.locationService
    }
    var dateService: DateService {
        return appComponent.dateService
    }
    var loginService: LoginService {
        return appComponent.loginService
    }
    private let appComponent: AppComponent
    private let homeComponent: HomeComponent
    init(appComponent: AppComponent, homeComponent: HomeComponent) {
        self.appComponent = appComponent
        self.homeComponent = homeComponent
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent
private class WritingMainPostDependencyeba8c3d3228ba588faa8Provider: WritingMainPostDependencyeba8c3d3228ba588faa8BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent as! AppComponent, homeComponent: component.parent as! HomeComponent)
    }
}
private class SelectDateModalDependency547a4536ad6f1082ff72BaseProvider: SelectDateModalDependency {
    var dateService: DateService {
        return appComponent.dateService
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->WritingMainPostComponent->SelectDateModalComponent
private class SelectDateModalDependency547a4536ad6f1082ff72Provider: SelectDateModalDependency547a4536ad6f1082ff72BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent.parent as! AppComponent)
    }
}
private class ApplicantListModalDependency04cfed02b61183a240faBaseProvider: ApplicantListModalDependency {
    var postAPIService: PostAPIService {
        return mainTabComponent.postAPIService
    }
    private let mainTabComponent: MainTabComponent
    init(mainTabComponent: MainTabComponent) {
        self.mainTabComponent = mainTabComponent
    }
}
/// ^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent->ApplicantListModalComponent
private class ApplicantListModalDependency04cfed02b61183a240faProvider: ApplicantListModalDependency04cfed02b61183a240faBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent.parent.parent as! MainTabComponent)
    }
}
/// ^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent->ApplicantListModalComponent
private class ApplicantListModalDependency369da0b8761222e1dadaProvider: ApplicantListModalDependency04cfed02b61183a240faBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent.parent.parent as! MainTabComponent)
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent->ApplicantListModalComponent
private class ApplicantListModalDependency38daf10a5dd5609ffa27Provider: ApplicantListModalDependency04cfed02b61183a240faBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent.parent.parent as! MainTabComponent)
    }
}
private class PostDetailDependencyefc8ed9cd9a796bab512BaseProvider: PostDetailDependency {
    var postAPIService: PostAPIService {
        return mainTabComponent.postAPIService
    }
    private let mainTabComponent: MainTabComponent
    init(mainTabComponent: MainTabComponent) {
        self.mainTabComponent = mainTabComponent
    }
}
/// ^->AppComponent->MainTabComponent->BookMarkComponent->PostDetailComponent
private class PostDetailDependencyefc8ed9cd9a796bab512Provider: PostDetailDependencyefc8ed9cd9a796bab512BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent.parent as! MainTabComponent)
    }
}
/// ^->AppComponent->MainTabComponent->MyPageComponent->PostDetailComponent
private class PostDetailDependencyfaba91a453a4115aa8d1Provider: PostDetailDependencyefc8ed9cd9a796bab512BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent.parent as! MainTabComponent)
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->PostDetailComponent
private class PostDetailDependency0e20bfa0f3e155bd15e3Provider: PostDetailDependencyefc8ed9cd9a796bab512BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(mainTabComponent: component.parent.parent as! MainTabComponent)
    }
}
private class HomeFilterDependency4c2395ae43750f0e6394BaseProvider: HomeFilterDependency {
    var locationService: LocationService {
        return homeComponent.locationService
    }
    private let homeComponent: HomeComponent
    init(homeComponent: HomeComponent) {
        self.homeComponent = homeComponent
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent->HomeFilterComponent
private class HomeFilterDependency4c2395ae43750f0e6394Provider: HomeFilterDependency4c2395ae43750f0e6394BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(homeComponent: component.parent as! HomeComponent)
    }
}
private class HomeDependency69aec7ecd6b5263bd0e9BaseProvider: HomeDependency {
    var dateService: DateService {
        return appComponent.dateService
    }
    var loginService: LoginService {
        return appComponent.loginService
    }
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    var postAPIService: PostAPIService {
        return mainTabComponent.postAPIService
    }
    private let appComponent: AppComponent
    private let mainTabComponent: MainTabComponent
    init(appComponent: AppComponent, mainTabComponent: MainTabComponent) {
        self.appComponent = appComponent
        self.mainTabComponent = mainTabComponent
    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent
private class HomeDependency69aec7ecd6b5263bd0e9Provider: HomeDependency69aec7ecd6b5263bd0e9BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent as! AppComponent, mainTabComponent: component.parent as! MainTabComponent)
    }
}
private class PolicyTermDependency28006fce607070d6ca75BaseProvider: PolicyTermDependency {
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    var signupKeyChainService: SignupKeyChainService {
        return loggedOutComponent.signupKeyChainService
    }
    private let appComponent: AppComponent
    private let loggedOutComponent: LoggedOutComponent
    init(appComponent: AppComponent, loggedOutComponent: LoggedOutComponent) {
        self.appComponent = appComponent
        self.loggedOutComponent = loggedOutComponent
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent
private class PolicyTermDependency28006fce607070d6ca75Provider: PolicyTermDependency28006fce607070d6ca75BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent as! AppComponent, loggedOutComponent: component.parent as! LoggedOutComponent)
    }
}
private class PolicyDetailDependencyab7a37b72bd8b136a461BaseProvider: PolicyDetailDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->PolicyDetailComponent
private class PolicyDetailDependencyab7a37b72bd8b136a461Provider: PolicyDetailDependencyab7a37b72bd8b136a461BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class WaitCertificationDependencya59e7f4494bb58452d1aBaseProvider: WaitCertificationDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent->WaitCertificationComponent
private class WaitCertificationDependencya59e7f4494bb58452d1aProvider: WaitCertificationDependencya59e7f4494bb58452d1aBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class OnboardingCompletionDependencyfab662889368f161b644BaseProvider: OnboardingCompletionDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->OnboardingCompletionComponent
private class OnboardingCompletionDependencyfab662889368f161b644Provider: OnboardingCompletionDependencyfab662889368f161b644BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class PhotoCertificationDependency919976e3bbe7c6970accBaseProvider: PhotoCertificationDependency {
    var signupService: SignupService {
        return emailCertificationComponent.signupService
    }
    private let emailCertificationComponent: EmailCertificationComponent
    init(emailCertificationComponent: EmailCertificationComponent) {
        self.emailCertificationComponent = emailCertificationComponent
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent
private class PhotoCertificationDependency919976e3bbe7c6970accProvider: PhotoCertificationDependency919976e3bbe7c6970accBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(emailCertificationComponent: component.parent as! EmailCertificationComponent)
    }
}
private class PhotoModalDependency256710ef3f831e315f20BaseProvider: PhotoModalDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent->PhotoModalComponent
private class PhotoModalDependency256710ef3f831e315f20Provider: PhotoModalDependency256710ef3f831e315f20BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class EmailCertificationDependencyf5f9a83429ebc20c0ea9BaseProvider: EmailCertificationDependency {
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    var signupKeyChainService: SignupKeyChainService {
        return loggedOutComponent.signupKeyChainService
    }
    private let appComponent: AppComponent
    private let loggedOutComponent: LoggedOutComponent
    init(appComponent: AppComponent, loggedOutComponent: LoggedOutComponent) {
        self.appComponent = appComponent
        self.loggedOutComponent = loggedOutComponent
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent
private class EmailCertificationDependencyf5f9a83429ebc20c0ea9Provider: EmailCertificationDependencyf5f9a83429ebc20c0ea9BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent.parent.parent.parent as! AppComponent, loggedOutComponent: component.parent.parent.parent.parent.parent as! LoggedOutComponent)
    }
}
private class EmailCertificationInitModalDependencyc0fcd95426abdc2eb784BaseProvider: EmailCertificationInitModalDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->EmailCertificationInitModalComponent
private class EmailCertificationInitModalDependencyc0fcd95426abdc2eb784Provider: EmailCertificationInitModalDependencyc0fcd95426abdc2eb784BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class BirthDependencyeacd7a6dc893684c63a8BaseProvider: BirthDependency {
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    var signupKeyChainService: SignupKeyChainService {
        return loggedOutComponent.signupKeyChainService
    }
    private let appComponent: AppComponent
    private let loggedOutComponent: LoggedOutComponent
    init(appComponent: AppComponent, loggedOutComponent: LoggedOutComponent) {
        self.appComponent = appComponent
        self.loggedOutComponent = loggedOutComponent
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent
private class BirthDependencyeacd7a6dc893684c63a8Provider: BirthDependencyeacd7a6dc893684c63a8BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent as! AppComponent, loggedOutComponent: component.parent.parent as! LoggedOutComponent)
    }
}
private class OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider: OnboardingCancelModalDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependency163a186c00ad3225b79bProvider: OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->PhotoCertificationComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependency680f661d1573dc6db5cbProvider: OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependency41086b612da017603ac7Provider: OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependencyd5d244529412faa64d91Provider: OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependencycb42558bc283046b72a5Provider: OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->OnboardingCancelModalComponent
private class OnboardingCancelModalDependency07be119931b373c0743bProvider: OnboardingCancelModalDependency163a186c00ad3225b79bBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class SelectJobGroupDependency2420d5f31bd0022c257fBaseProvider: SelectJobGroupDependency {
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    var signupKeyChainService: SignupKeyChainService {
        return loggedOutComponent.signupKeyChainService
    }
    private let appComponent: AppComponent
    private let loggedOutComponent: LoggedOutComponent
    init(appComponent: AppComponent, loggedOutComponent: LoggedOutComponent) {
        self.appComponent = appComponent
        self.loggedOutComponent = loggedOutComponent
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent
private class SelectJobGroupDependency2420d5f31bd0022c257fProvider: SelectJobGroupDependency2420d5f31bd0022c257fBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent.parent.parent as! AppComponent, loggedOutComponent: component.parent.parent.parent.parent as! LoggedOutComponent)
    }
}
private class SelectGenderDependency1501a6b74f78c8951e52BaseProvider: SelectGenderDependency {
    var loginKeyChainService: LoginKeyChainService {
        return appComponent.loginKeyChainService
    }
    var signupKeyChainService: SignupKeyChainService {
        return loggedOutComponent.signupKeyChainService
    }
    private let appComponent: AppComponent
    private let loggedOutComponent: LoggedOutComponent
    init(appComponent: AppComponent, loggedOutComponent: LoggedOutComponent) {
        self.appComponent = appComponent
        self.loggedOutComponent = loggedOutComponent
    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent
private class SelectGenderDependency1501a6b74f78c8951e52Provider: SelectGenderDependency1501a6b74f78c8951e52BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(appComponent: component.parent.parent.parent.parent as! AppComponent, loggedOutComponent: component.parent.parent.parent as! LoggedOutComponent)
    }
}
