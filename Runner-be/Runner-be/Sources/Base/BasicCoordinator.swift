//
//  BasicCoordinator.swift
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
        Log.d(tag: .lifeCycle, "Coordinator Initialized")
        navigationController = navController
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    deinit {
        Log.d(tag: .lifeCycle, "Coordinator Deinitialized")
    }

    // MARK: Internal

    typealias CoordinationResult = ResultType

    var identifier: String { "\(Self.self)" }
    var sceneDisposeBag = DisposeBag()

    var navigationController: UINavigationController

    var childCoordinators = [String: Coordinator]()
    var childCloseSignalBags = [String: [Disposable]]()

    var closeSignal = PublishSubject<CoordinationResult>()

    func coordinate<T>(coordinator: BasicCoordinator<T>, animated: Bool = true, needRelease: Bool = true, onCloseSignal: ((T) -> Void)? = nil) {
        let disposable = coordinate(coordinator: coordinator, animated: animated)
            .subscribe(onNext: { [weak self] coordResult in
                defer {
                    if needRelease {
                        self?.releaseChild(coordinator: coordinator)
                    }
                }
                onCloseSignal?(coordResult)
            })

        addChildDisposable(id: coordinator.identifier, disposable: disposable)
    }

    @discardableResult
    private func coordinate<T>(coordinator: BasicCoordinator<T>, animated: Bool = true) -> Observable<T> {
        childCoordinators[coordinator.identifier] = coordinator
        coordinator.start(animated: animated)
        return coordinator.closeSignal
    }

    private func addChildDisposable(id: String, disposable: Disposable) {
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
        childCoordinators.forEach { _, coord in coord.release() }
        childCloseSignalBags.flatMap { $1 }.forEach { $0.dispose() }
        childCoordinators.removeAll()
        childCloseSignalBags.removeAll()
    }

    func start(animated _: Bool) {
        fatalError("start() must be impl")
    }

    func handleDeepLink(type _: DeepLinkType) {}
}
