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
            .disposed(by: disposeBags)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.tapCancel)
            .disposed(by: disposeBags)

        nextButton.rx.tap
            .bind(to: viewModel.inputs.tapNext)
            .disposed(by: disposeBags)

        jobGroup.tap
            .compactMap { $0 }
            .map { [weak self] numSelected in
                guard let self = self else { return [] }
                return (numSelected != 0) ? self.jobGroup.selected : []
            }
            .bind(to: viewModel.inputs.tapGroup)
            .disposed(by: disposeBags)

        // TODO: 직군 종류들을 ViewModel로 넘길지 고민해보기
        let jobGroupLabels = Observable.of(jobLabels)
        jobGroupLabels.bind(
            to: jobGroupCollectionView.rx.items(
                cellIdentifier: JobGroupCollectionViewCell.id,
                cellType: JobGroupCollectionViewCell.self
            )
        ) { _, label, cell in cell.label = label }
            .disposed(by: disposeBags)
    }

    private func viewModelOutput() {
        viewModel.outputs.enableNext
            .subscribe(onNext: { [weak self] enable in
                self?.nextButton.isEnabled = enable
            })
            .disposed(by: disposeBags)
    }

    // MARK: Private

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.font = .iosBody17Sb
        navBar.titleLabel.text = L10n.SelectGender.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }

    private var titleLabel1 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.SelectJobGroup.title1
    }

    private var titleLabel2 = UILabel().then { label in
        label.font = UIFont.iosHeader31Sb
        label.textColor = .primary
        label.text = L10n.SelectJobGroup.title2
    }

    private var subTitleLabel = UILabel().then { label in
        label.font = UIFont.iosBody15R
        label.textColor = .darkG25
        label.text = L10n.SelectJobGroup.subTitle
    }

    private var jobLabels = [
        OnOffLabel(text: L10n.SelectJobGroup.Group._1),
        OnOffLabel(text: L10n.SelectJobGroup.Group._2),
        OnOffLabel(text: L10n.SelectJobGroup.Group._3),
        OnOffLabel(text: L10n.SelectJobGroup.Group._4),
        OnOffLabel(text: L10n.SelectJobGroup.Group._5),
        OnOffLabel(text: L10n.SelectJobGroup.Group._6),
        OnOffLabel(text: L10n.SelectJobGroup.Group._7),
        OnOffLabel(text: L10n.SelectJobGroup.Group._8),
        OnOffLabel(text: L10n.SelectJobGroup.Group._9),
        OnOffLabel(text: L10n.SelectJobGroup.Group._10),
        OnOffLabel(text: L10n.SelectJobGroup.Group._11),
        OnOffLabel(text: L10n.SelectJobGroup.Group._12),
        OnOffLabel(text: L10n.SelectJobGroup.Group._13),
        OnOffLabel(text: L10n.SelectJobGroup.Group._14),
    ]

    private var jobGroup = OnOffLabelGroup().then { group in
        group.styleOn = OnOffLabel.Style(
            font: .iosBody15R,
            backgroundColor: .clear,
            textColor: .primary,
            borderWidth: 1,
            borderColor: .primary,
            cornerRadiusRatio: 1,
            padding: UIEdgeInsets(top: 6, left: 19, bottom: 8, right: 19)
        )

        group.styleOff = OnOffLabel.Style(
            font: .iosBody15R,
            backgroundColor: .clear,
            textColor: .darkG35,
            borderWidth: 1,
            borderColor: .darkG35,
            cornerRadiusRatio: 1,
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

    private var nextButton = UIButton().then { button in
        button.setTitle(L10n.PolicyTerm.Button.Next.title, for: .normal)
        button.setTitleColor(UIColor.darkBlack, for: .normal)
        button.setBackgroundColor(UIColor.primary, for: .normal)

        button.setTitle(L10n.PolicyTerm.Button.Next.title, for: .disabled)
        button.setTitleColor(UIColor.darkG45, for: .disabled)
        button.setBackgroundColor(UIColor.darkG3, for: .disabled)

        button.titleLabel?.font = .iosBody15R

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
            nextButton,
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
        }

        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading).offset(16)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(12)
            make.leading.equalTo(view.snp.leading).offset(18)
        }

        jobGroupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(76)
            make.leading.equalTo(view.snp.leading).offset(56)
            make.trailing.equalTo(view.snp.trailing).offset(-56)
            make.height.equalTo(244)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-21)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(48)
        }
        nextButton.layer.cornerRadius = 24
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
