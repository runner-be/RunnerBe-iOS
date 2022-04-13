//
//  0_BasicCoordinator.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxSwift
import UIKit

protocol Coordinator: AnyObject {
    var identifier: String { get }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [String: Coordinator] { get set }
    var childCloseSignalBags: [String: [Disposable]] { get set }
    func release()
    func releaseChild(coordinator: Coordinator)

    func handleDeepLink(type: DeepLinkType)
}

class BasicCoordinator<ResultType>: Coordinator {
    // MARK: Lifecycle

    init(navController: UINavigationController) {
        #if DEBUG
            print("[init:   Coord]  \(Self.self)")
        #endif
        navigationController = navController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    deinit {
        #if DEBUG
            print("[deinit: Coord]  \(Self.self)")
        #endif
    }

    // MARK: Internal

    typealias CoordinationResult = ResultType

    var identifier: String { "\(Self.self)" }
    var sceneDisposeBag = DisposeBag()

    var navigationController: UINavigationController

    var childCoordinators = [String: Coordinator]()
    var childCloseSignalBags = [String: [Disposable]]()

    var closeSignal = PublishSubject<CoordinationResult>()

    @discardableResult
    func coordinate<T>(coordinator: BasicCoordinator<T>, animated: Bool = true) -> Observable<T> {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start(animated: animated)
        return coordinator.closeSignal
    }

    func addChildDisposable(id: String, disposable: Disposable) {
        childCloseSignalBags[id, default: []].append(disposable)
    }

    func releaseChild(coordinator: Coordinator) {
        coordinator.release()
        let id = coordinator.identifier
        childCloseSignalBags[id]?.forEach { $0.dispose() }
        childCoordinators.removeValue(forKey: id)
        childCloseSignalBags.removeValue(forKey: id)
    }

    func release() {
        #if DEBUG
            print("[release:    Coord]  \(Self.self)")
        #endif
        childCoordinators.forEach { _, coord in coord.release() }
        childCloseSignalBags.flatMap { $1 }.forEach { $0.dispose() }
        childCoordinators.removeAll()
        childCloseSignalBags.removeAll()

        #if DEBUG
            print("[released:   Coord]   \(Self.self)")
        #endif
    }

    func start(animated _: Bool) {
        fatalError("start() must be impl")
    }

    func handleDeepLink(type _: DeepLinkType) {}
}
