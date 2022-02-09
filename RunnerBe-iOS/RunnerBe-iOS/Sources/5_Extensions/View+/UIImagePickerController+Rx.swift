//
//  UIImagePickerController+RxCreate.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 1/10/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

public extension Reactive where Base: UIImagePickerController {
    internal static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { _ in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })

            do {
                try configureImagePicker(imagePicker)
            } catch {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))

            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map { a in
                try castOrThrow([UIImagePickerController.InfoKey: AnyObject].self, a[1])
            }
    }

    /**
     Reactive wrapper for `delegate` message.
     */
    var didCancel: Observable<Void> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map { _ in () }
    }
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
