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
    func release()
}

class BasicCoordinator<ResultType>: Coordinator {
    // MARK: Lifecycle

    init(navController: UINavigationController) {
        #if DEBUG
            print("[init:   Coord]  \(Self.self)")
        #endif
        self.navController = navController
        navController.setNavigationBarHidden(true, animated: false)
    }

    deinit {
        #if DEBUG
            print("[deinit: Coord]  \(Self.self)")
        #endif
    }

    // MARK: Internal

    typealias CoordinationResult = ResultType

    let uuid = UUID()
    var disposeBag = DisposeBag()

    var navController: UINavigationController

    var childs = [UUID: Coordinator]()
    var childBags = [UUID: [Disposable]]()

    var closeSignal = PublishSubject<CoordinationResult>()

    @discardableResult
    func coordinate<T>(coordinator: BasicCoordinator<T>) -> Observable<T> {
        childs[coordinator.uuid] = coordinator
        coordinator.start()
        return coordinator.closeSignal
    }

    func addChildBag(uuid: UUID, disposable: Disposable) {
        childBags[uuid, default: []].append(disposable)
    }

    func release<T>(coordinator: BasicCoordinator<T>) {
        coordinator.release()
        let uuid = coordinator.uuid
        childBags[uuid]?.forEach { $0.dispose() }
        childs.removeValue(forKey: uuid)
        childBags.removeValue(forKey: uuid)
    }

    func release() {
        #if DEBUG
            print("[release:    Coord]  \(Self.self)")
        #endif
        childs.forEach { _, coord in coord.release() }
        childBags.flatMap { $1 }
            .forEach { $0.dispose() }
        childs.removeAll()
        childBags.removeAll()
        #if DEBUG
            print("[released:   Coord]   \(Self.self)")
        #endif
    }

    func start() {
        fatalError("start() must be impl")
    }

    // MARK: Private

    private func store<T>(coordinator: BasicCoordinator<T>) {
        childs[coordinator.uuid] = coordinator
    }
}
