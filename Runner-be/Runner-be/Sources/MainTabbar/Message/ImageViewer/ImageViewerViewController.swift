//
//  ImageViewerViewController.swift
//  Runner-be
//
//  Created by 김창규 on 7/11/24.
//

import Kingfisher
import UIKit

final class ImageViewerViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: ImageViewerViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: ImageViewerViewModel

    private func viewModelInput() {
        cancleButton.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.image
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let cancleButton = UIButton().then {
        $0.setImage(Asset.x.uiImage, for: .normal)
    }
}

// MARK: - Layout

extension ImageViewerViewController {
    private func setupViews() {
        view.backgroundColor = .black

        view.addSubviews([
            imageView,
            cancleButton,
        ])
    }

    private func initialLayout() {
        imageView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        cancleButton.snp.makeConstraints {
            $0.right.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.size.equalTo(20)
        }
    }
}
