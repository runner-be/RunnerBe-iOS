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
            .disposed(by: disposeBag)

        finishingBtn.rx.tap
            .bind(to: viewModel.inputs.finishing)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

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
            .disposed(by: disposeBag)

        viewModel.outputs.participants
            .map { !$0.isEmpty }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)
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
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserInfoAcceptableCell.self, forCellWithReuseIdentifier: UserInfoAcceptableCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var emptyLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.text = L10n.Home.PostDetail.Participant.empty
        label.textColor = .darkG45
        label.isHidden = true
    }

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
        setBackgroundColor()

        view.addSubviews([
            titleLabel,
            closeBtn,
            collectionView,
            finishingBtn,
        ])

        collectionView.addSubviews([emptyLabel])
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
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        finishingBtn.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(40)
        }
        finishingBtn.layer.cornerRadius = 20

        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(collectionView.snp.center)
        }
    }
}

extension ApplicantListModalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return UserInfoAcceptableCell.size
    }
}
