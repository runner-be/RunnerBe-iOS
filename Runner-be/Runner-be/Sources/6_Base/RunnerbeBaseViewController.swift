//
//  RunnerbeBaseViewController.swift
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

class RunnerbeBaseViewController: UIViewController {
    // MARK: Lifecycle

    init() {
        #if DEBUG
            print("[init:   VC] \(Self.self)")
        #endif
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        #if DEBUG
            print("[deinit: VC] \(Self.self)")
        #endif
    }

    // MARK: Internal

    var disposeBag = DisposeBag()
}

// MARK: - Base Functions

extension RunnerbeBaseViewController {
    func gradientBackground(topColor: UIColor = .bgTop, bottomColor: UIColor = .bgBottom) {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            bottomColor.cgColor,
            topColor.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
