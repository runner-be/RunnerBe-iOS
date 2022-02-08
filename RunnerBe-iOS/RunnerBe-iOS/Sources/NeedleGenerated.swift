

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
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MessageComponent") { component in
        return MessageDependencyb26316582fc24834a34cProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->MyPageComponent") { component in
        return MyPageDependencyed3a2dbc57f299854a2fProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->MainTabComponent->HomeComponent") { component in
        return HomeDependency69aec7ecd6b5263bd0e9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent") { component in
        return PolicyTermDependency28006fce607070d6ca75Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent") { component in
        return EmailCertificationDependencyf5f9a83429ebc20c0ea9Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent") { component in
        return BirthDependencyeacd7a6dc893684c63a8Provider(component: component)
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
    var kakaoLoginService: KakaoLoginService {
        return appComponent.kakaoLoginService
    }
    var naverLoginService: NaverLoginService {
        return appComponent.naverLoginService
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


    init() {

    }
}
/// ^->AppComponent->MainTabComponent
private class MainTabDependency2826cdb310ed0b17a725Provider: MainTabDependency2826cdb310ed0b17a725BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class BookMarkDependency0c4e86716ba3aaf84ee1BaseProvider: BookMarkDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->BookMarkComponent
private class BookMarkDependency0c4e86716ba3aaf84ee1Provider: BookMarkDependency0c4e86716ba3aaf84ee1BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class MessageDependencyb26316582fc24834a34cBaseProvider: MessageDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->MessageComponent
private class MessageDependencyb26316582fc24834a34cProvider: MessageDependencyb26316582fc24834a34cBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class MyPageDependencyed3a2dbc57f299854a2fBaseProvider: MyPageDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->MyPageComponent
private class MyPageDependencyed3a2dbc57f299854a2fProvider: MyPageDependencyed3a2dbc57f299854a2fBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class HomeDependency69aec7ecd6b5263bd0e9BaseProvider: HomeDependency {


    init() {

    }
}
/// ^->AppComponent->MainTabComponent->HomeComponent
private class HomeDependency69aec7ecd6b5263bd0e9Provider: HomeDependency69aec7ecd6b5263bd0e9BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class PolicyTermDependency28006fce607070d6ca75BaseProvider: PolicyTermDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent
private class PolicyTermDependency28006fce607070d6ca75Provider: PolicyTermDependency28006fce607070d6ca75BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class EmailCertificationDependencyf5f9a83429ebc20c0ea9BaseProvider: EmailCertificationDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent->EmailCertificationComponent
private class EmailCertificationDependencyf5f9a83429ebc20c0ea9Provider: EmailCertificationDependencyf5f9a83429ebc20c0ea9BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class BirthDependencyeacd7a6dc893684c63a8BaseProvider: BirthDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent
private class BirthDependencyeacd7a6dc893684c63a8Provider: BirthDependencyeacd7a6dc893684c63a8BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class SelectJobGroupDependency2420d5f31bd0022c257fBaseProvider: SelectJobGroupDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent->SelectJobGroupComponent
private class SelectJobGroupDependency2420d5f31bd0022c257fProvider: SelectJobGroupDependency2420d5f31bd0022c257fBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
private class SelectGenderDependency1501a6b74f78c8951e52BaseProvider: SelectGenderDependency {


    init() {

    }
}
/// ^->AppComponent->LoggedOutComponent->PolicyTermComponent->BirthComponent->SelectGenderComponent
private class SelectGenderDependency1501a6b74f78c8951e52Provider: SelectGenderDependency1501a6b74f78c8951e52BaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init()
    }
}
