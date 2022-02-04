//
//  0_BasicCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

protocol Coordinator: AnyObject {
    var uuid: UUID { get }
    var navController: UINavigationController { get set }
    var childs: [UUID: Coordinator] { get set }
}

class BasicCoordinator<ResultType>: Coordinator {
    typealias CoordinationResult = ResultType

    let uuid = UUID()
    var navController: UINavigationController

    var childs = [UUID: Coordinator]()
    var closeBags = [UUID: Disposable]()

    var closeSignal = PublishSubject<CoordinationResult>()

    init(navController: UINavigationController) {
        self.navController = navController
        navController.setNavigationBarHidden(true, animated: false)
    }

    private func store<T>(coordinator: BasicCoordinator<T>) {
        childs[coordinator.uuid] = coordinator
    }

    @discardableResult
    func coordinate<T>(coordinator: BasicCoordinator<T>) -> Observable<T> {
        childs[coordinator.uuid] = coordinator
        coordinator.start()
        return coordinator.closeSignal
    }

    func release<T>(coordinator: BasicCoordinator<T>) {
        let uuid = coordinator.uuid
        childs[uuid] = nil
        closeBags[uuid]?.dispose()
        closeBags.removeValue(forKey: uuid)
    }

    func start() {
        fatalError("start() must be impl")
    }
}
