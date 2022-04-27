//
//  MessageViewController.swift
//  Runner-be
//
//  Created by 김신우 on 2022/04/26.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class MessageViewController: RunnerbeBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: MessageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MessageViewModel

    private func viewModelInput() {}
    private func viewModelOutput() {}
}

// MARK: - Layout

extension MessageViewController {
    private func setupViews() {
        gradientBackground()
    }

    private func initialLayout() {}
}
