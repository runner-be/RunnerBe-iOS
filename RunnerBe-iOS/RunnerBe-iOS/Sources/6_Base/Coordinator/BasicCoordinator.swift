//
//  0_BasicCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

protocol Coordinator: AnyObject {
    var id: String { get }
    var navController: UINavigationController { get set }
    var childs: [String: Coordinator] { get set }
    var childBags: [String: [Disposable]] { get set }
    func release()
    func release(coordinator: Coordinator)

    func handleDeepLink(type: DeepLinkType)
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

    var id: String { "\(Self.self)" }
    var disposeBag = DisposeBag()

    var navController: UINavigationController

    var childs = [String: Coordinator]()
    var childBags = [String: [Disposable]]()

    var closeSignal = PublishSubject<CoordinationResult>()

    @discardableResult
    func coordinate<T>(coordinator: BasicCoordinator<T>, animated: Bool = true) -> Observable<T> {
        childs[coordinator.id] = coordinator
        coordinator.start(animated: animated)
        return coordinator.closeSignal
    }

    func addChildBag(id: String, disposable: Disposable) {
        childBags[id, default: []].append(disposable)
    }

    func release(coordinator: Coordinator) {
        coordinator.release()
        let id = coordinator.id
        childBags[id]?.forEach { $0.dispose() }
        childs.removeValue(forKey: id)
        childBags.removeValue(forKey: id)
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

    func start(animated _: Bool) {
        fatalError("start() must be impl")
    }

    func handleDeepLink(type _: DeepLinkType) {}

    // MARK: Private

    private func store<T>(coordinator: BasicCoordinator<T>) {
        childs[coordinator.id] = coordinator
    }
}
