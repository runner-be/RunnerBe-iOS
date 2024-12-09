//
//  BaseViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class BaseViewController: UIViewController {
    // MARK: - Peroperties

    var keyboardHeight: CGFloat?

    // MARK: Lifecycle

    init() {
        Log.d(tag: .lifeCycle, "VC Initialized")
        super.init(nibName: nil, bundle: nil)

        // 키보드 알림 등록
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Log.d(tag: .lifeCycle, "VC Deinitialized")
    }

    // MARK: Internal

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - Base Functions

extension BaseViewController: UIGestureRecognizerDelegate {
    func setBackgroundColor() {
        view.backgroundColor = .darkG7
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    func dismissKeyboardWhenTappedAround() {
        let tap =
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(false)
    }

    func gestureRecognizer(_: UIGestureRecognizer, shouldBeRequiredToFailBy _: UIGestureRecognizer) -> Bool {
        dismissKeyboard() // 제스처로 뒤로가기할 때 키보드 없애야함
        return true
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        } else {
            print("Keyboard Frame not found")
        }
    }
}
