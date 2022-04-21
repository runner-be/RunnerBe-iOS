//
//  SelectJobGroupViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/08.
//

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

final class SelectJobGroupViewController: BaseViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    init(viewModel: SelectJobGroupViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewModel Binding

    private var viewModel: SelectJobGroupViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapBackward)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .bind(to: viewModel.inputs.tapComplete)
            .disposed(by: disposeBag)

        jobGroup.tap
            .compactMap { $0 }
            .map { [weak self] numSelected in
                guard let self = self else { return [] }
                return (numSelected != 0) ? self.jobGroup.selected : []
            }
            .bind(to: viewModel.inputs.tapGroup)
            .disposed(by: disposeBag)

        // TODO: 직군 종류들을 ViewModel로 넘길지 고민해보기
        let jobGroupLabels = Observable.of(jobLabels)
        jobGroupLabels.bind(
            to: jobGroupCollectionView.rx.items(
                cellIdentifier: JobGroupCollectionViewCell.id,
                cellType: JobGroupCollectionViewCell.self
            )
        ) { _, label, cell in cell.label = label }
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableComplete
            .subscribe(onNext: { [weak self] enable in
                self?.completeButton.isEnabled = enable
            })
            .disposed(by: disposeBag)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.Onboarding.Job.title1
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.Onboarding.Job.title2
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
    }

    private var subTitleLabel = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.Onboarding.Job.subTitle
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
    }

    private var jobLabels = Job.allCases.reduce(into: [OnOffLabel]()) { partialResult, job in
        if job != .none {
            partialResult.append(OnOffLabel(text: job.name))
        }
    }

    private var jobGroup = OnOffLabelGroup().then { group in
        group.styleOn = OnOffLabel.Style(
            font: .iosBody15R,
            backgroundColor: .clear,
            textColor: .primary,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.styleOff = OnOffLabel.Style(
            font: .iosBody15R,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
            useCornerRadiusAsFactor: true,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.maxNumberOfOnState = 1
    }

    var jobGroupCollectionView: UICollectionView = {
        var layout = JobGroupCollectionViewLayout()
        layout.xSpacing = 12
        layout.ySpacing = 16
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(JobGroupCollectionViewCell.self, forCellWithReuseIdentifier: JobGroupCollectionViewCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var completeButton = UIButton().then { button in
        button.setTitle(L10n.Onboarding.Job.Button.Next.title, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.Onboarding.Job.Button.Next.title, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15B

        button.clipsToBounds = true

        button.isEnabled = false
    }
}

// MARK: - Layout

extension SelectJobGroupViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            titleLabel1,
            titleLabel2,
            subTitleLabel,
            jobGroupCollectionView,
            completeButton,
        ])

        jobGroup.append(labels: jobLabels)
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(26)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-185)
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-185)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(18)
            make.trailing.equalTo(view.snp.trailing).offset(-137)
        }

        jobGroupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(76)
            make.leading.equalTo(view.snp.leading).offset(55)
            make.trailing.equalTo(view.snp.trailing).offset(-55)
            make.height.equalTo(244)
        }

        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        completeButton.layer.cornerRadius = 24
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
