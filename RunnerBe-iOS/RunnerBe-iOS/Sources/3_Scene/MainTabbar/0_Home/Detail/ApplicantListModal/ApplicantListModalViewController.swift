//
//  ApplicantListModalViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/26.
//

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

class ApplicantListModalViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: ApplicantListModalViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: ApplicantListModalViewModel

    private func viewModelInput() {
        closeBtn.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBags)

        finishingBtn.rx.tap
            .bind(to: viewModel.inputs.finishing)
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        typealias UserAcceptableCellDataSource = RxCollectionViewSectionedAnimatedDataSource<UserInfoAcceaptableSection>

        let dataSource = UserAcceptableCellDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoAcceptableCell.id, for: indexPath) as? UserInfoAcceptableCell
                else { return UICollectionViewCell() }

                cell.setup(userInfo: element)

                cell.acceptBtn.rx.tap
                    .map { (idx: indexPath.row, accept: true) }
                    .bind(to: self.viewModel.inputs.accept)
                    .disposed(by: cell.disposeBag)

                cell.refusalBtn.rx.tap
                    .map { (idx: indexPath.row, accept: false) }
                    .bind(to: self.viewModel.inputs.accept)
                    .disposed(by: cell.disposeBag)

                return cell
            }
        )

        viewModel.outputs.participants
            .debug()
            .map { [UserInfoAcceaptableSection(items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBags)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBags)
    }

    private var closeBtn = UIButton().then { button in
        button.setImage(Asset.x.uiImage, for: .normal)
    }

    private var titleLabel = UILabel().then { label in
        label.font = .iosBody17Sb
        label.textColor = .darkG2
        label.text = L10n.Home.PostDetail.Participant.title
    }

    private lazy var collectionView: UICollectionView = {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(143)
        )
        var item = NSCollectionLayoutItem(layoutSize: size)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(12),
            trailing: .fixed(0),
            bottom: .fixed(12)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserInfoAcceptableCell.self, forCellWithReuseIdentifier: UserInfoAcceptableCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var finishingBtn = UIButton().then { button in
        button.setTitle(L10n.Home.PostDetail.Writer.finishing, for: .normal)
        button.setTitleColor(.darkG6, for: .normal)
        button.setBackgroundColor(.primary, for: .normal)
        button.titleLabel?.font = .iosBody15B
        button.clipsToBounds = true
    }
}

// MARK: - Layout

extension ApplicantListModalViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            titleLabel,
            closeBtn,
            collectionView,
            finishingBtn,
        ])
    }

    private func initialLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        closeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        finishingBtn.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(40)
        }
        finishingBtn.layer.cornerRadius = 20
    }

    private func gradientBackground() {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [
            UIColor.bgBottom.cgColor,
            UIColor.bgTop.cgColor,
        ]
        backgroundGradientLayer.frame = view.bounds
        view.layer.addSublayer(backgroundGradientLayer)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
