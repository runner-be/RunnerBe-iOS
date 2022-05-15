//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageChatResult {}

final class MessageChatCoordinator: BasicCoordinator<MessageChatResult> {
    var component: MessageChatComponent

    init(component: MessageChatComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: true)

        closeSignal
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: sceneDisposeBag)
//
//        scene.VM.routes.report
//            .map { scene.VM }
//            .subscribe(onNext: { [weak self] vm in
//                self?.presentReportModal(vm: vm, animated: false)
//            })
//            .disposed(by: sceneDisposeBag)
    }

    /*  자식 화면을 띄워야 하는 경우 다음 형태의 함수를 정의하여 처리하면 됩니다.
           1.    component를 통해 자식 씬의 component 생성,
           2.    생성된 component로 자식 씬의 coordinator 생성
           3.    let disposable = coordinate(coordinator: coord, animated: animated)로
               자식 coordinator 시작
           4.    subscribe를 통해 자식 coordinator의 closeSignal 바인딩
           5.    addChildDisposable을 통해 disposable 저장
             모든 push~Scene, present~Scene 함수는 위 형태를 따릅니다.
     */

//    private func presentReportModal(vm: MessageChatViewModel, animated: Bool) {
//        let comp = component.reportModalComponent
//        let coord = ReportModalCoordinator(component: comp, navController: navigationController)
//
//        let disposable = coordinate(coordinator: coord, animated: animated)
//            .subscribe(onNext: { [weak self] coordResult in
//                defer { self?.releaseChild(coordinator: coord) }
//                switch coordResult {
//                case .ok:
//                    vm.routes.report.onNext(true)
//                case .cancel:
//                    vm.routeInputs.report.onNext(false)
//                }
//            })
//
//        addChildDisposable(id: coord.identifier, disposable: disposable)
//    }
}
