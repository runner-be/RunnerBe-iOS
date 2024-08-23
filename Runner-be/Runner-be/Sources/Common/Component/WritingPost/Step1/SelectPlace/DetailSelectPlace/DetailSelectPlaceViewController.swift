//
//  DetailSelectPlaceViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/23/24.
//

import UIKit

final class DetailSelectPlaceViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: DetailSelectPlaceViewModel

    // MARK: - UI

    // MARK: - Init

    init(viewModel: DetailSelectPlaceViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        initialLayout()
    }
}

// MARK: - Layout

extension DetailSelectPlaceViewController {
    private func setupViews() {}

    private func initialLayout() {}
}
