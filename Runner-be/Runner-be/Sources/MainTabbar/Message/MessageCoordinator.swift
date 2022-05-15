//
//  MessageCoordinator.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import Foundation
import RxSwift

enum MessageResult {}

final class MessageCoordinator: BasicCoordinator<MessageResult> {
    var component: MessageComponent

    init(component: MessageComponent, navController: UINavigationController) {
        self.component = component
        super.init(navController: navController)
    }

    override func start(animated _: Bool) {
        let scene = component.scene

        scene.VM.routes.messageDelete
            .map { scene.VM }
            .subscribe(onNext: { [weak self] vm in
                self?.pushMessageDeleteScene(vm: vm, animated: true)
            })
            .disposed(by: sceneDisposeBag) // 구독 중단
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

    func pushMessageDeleteScene(vm _: MessageViewModel, animated: Bool) {
        let comp = component.messageDeleteComponent
        let coord = MessageDeleteCoordinator(component: comp, navController: navigationController)

        let disposable = coordinate(coordinator: coord, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                /*  *   defer를 통하여 closeSignal 처리 후 자식 coordinator를 해제해주어야 메모리에서 온전히 해제됩니다. */
                defer { self?.releaseChild(coordinator: coord) }
                switch coordResult {
                case .backward: // 해당 화면에서의 동작 처리
                    break
                }
            })

        addChildDisposable(id: coord.identifier, disposable: disposable)
    }
}
