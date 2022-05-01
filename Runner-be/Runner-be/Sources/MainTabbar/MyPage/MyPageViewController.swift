//
//  MyPageViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/05.
//
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Then
import Toast_Swift
import UIKit

class MyPageViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()
    }

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: MyPageViewModel

    private func viewModelInput() {
        writtenTab.rx.tap
            .map { MyPageViewModel.PostType.basic }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBag)

        participantTab.rx.tap
            .map { MyPageViewModel.PostType.attendable }
            .bind(to: viewModel.inputs.typeChanged)
            .disposed(by: disposeBag)

        myInfoWithChevron.chevronBtn.rx.tap
            .bind(to: viewModel.inputs.editInfo)
            .disposed(by: disposeBag)

        navBar.rightBtnItem.rx.tap
            .bind(to: viewModel.inputs.settings)
            .disposed(by: disposeBag)

        myPostCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)

        myRunningCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPost)
            .disposed(by: disposeBag)

        myPostEmptyButton.rx.tap
            .bind(to: viewModel.inputs.writePost)
            .disposed(by: disposeBag)

        myRunningEmptyButton.rx.tap
            .bind(to: viewModel.inputs.toMain)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        myPostCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        myRunningCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

        typealias MyPagePostDataSource
            = RxCollectionViewSectionedAnimatedDataSource<MyPagePostSection>

        let myPostDatasource = MyPagePostDataSource { _, collectionView, indexPath, item in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicPostCell.id, for: indexPath) as? BasicPostCell
            else { return UICollectionViewCell() }
            cell.configure(with: item.cellConfig)
            cell.postInfoView.bookMarkIcon.isHidden = true

            return cell
        }

        viewModel.outputs.posts
            .filter { [unowned self] _ in self.viewModel.outputs.postType == .basic }
            .map { [MyPagePostSection(items: $0)] }
            .bind(to: myPostCollectionView.rx.items(dataSource: myPostDatasource))
            .disposed(by: disposeBag)

        let myRunningDatasource = MyPagePostDataSource { [weak self] _, collectionView, indexPath, item in
            guard let self = self
            else { return UICollectionViewCell() }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendablePostCell.id, for: indexPath) as? AttendablePostCell
            else { return UICollectionViewCell() }
            cell.configure(with: item)

            cell.attendButton.rx.tap
                .map { indexPath.item }
                .bind(to: self.viewModel.inputs.attend)
                .disposed(by: cell.disposeBag)

            cell.postInfoView.bookMarkIcon.rx.tap
                .map { indexPath.item }
                .bind(to: self.viewModel.inputs.bookMark)
                .disposed(by: cell.disposeBag)

            self.viewModel.outputs.marked
                .filter { $0.type == .attendable }
                .filter { $0.idx == indexPath.item }
                .subscribe(onNext: { [weak cell] result in
                    cell?.postInfoView.bookMarkIcon.isSelected = result.marked
                })
                .disposed(by: cell.disposeBag)

            self.viewModel.outputs.attend
                .filter { $0.type == .attendable }
                .filter { $0.idx == indexPath.item }
                .subscribe(onNext: { [weak cell] result in
                    cell?.update(with: result.state)
                })
                .disposed(by: cell.disposeBag)

            return cell
        }

        viewModel.outputs.posts
            .filter { [unowned self] _ in self.viewModel.outputs.postType == .attendable }
            .map { [MyPagePostSection(items: $0)] }
            .bind(to: myRunningCollectionView.rx.items(dataSource: myRunningDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.posts
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] empty in
                guard let self = self else { return }
                let type = self.viewModel.outputs.postType

                switch type {
                case .attendable:
                    self.myPostCollectionView.isHidden = true
                    self.myRunningCollectionView.isHidden = false

                    self.myRunningEmptyLabel.isHidden = !empty
                    self.myRunningEmptyButton.isHidden = !empty
                case .basic:
                    self.myRunningCollectionView.isHidden = true
                    self.myPostCollectionView.isHidden = false

                    self.myPostEmptyLabel.isHidden = !empty
                    self.myPostEmptyButton.isHidden = !empty
                }

            })
            .disposed(by: disposeBag)

        viewModel.outputs.userInfo
            .subscribe(onNext: { [weak self] config in
                self?.myInfoWithChevron.infoView.configure(with: config)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.toast
            .subscribe(onNext: { [weak self] message in
                self?.view.makeToast(message)
            })
            .disposed(by: disposeBag)
    }

    private func viewInputs() {
        writtenTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.writtenTab.isSelected = true
                self.hMover.snp.removeConstraints()
                self.hMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(hDivider.snp.bottom)
                    make.leading.equalTo(writtenTab.snp.leading).offset(16)
                    make.trailing.equalTo(writtenTab.snp.trailing).offset(-16)
                }
                self.participantTab.isSelected = false
            })
            .disposed(by: disposeBag)

        participantTab.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.participantTab.isSelected = true
                self.hMover.snp.removeConstraints()
                self.hMover.snp.updateConstraints { make in
                    make.height.equalTo(2)
                    make.bottom.equalTo(hDivider.snp.bottom)
                    make.leading.equalTo(participantTab.snp.leading).offset(16)
                    make.trailing.equalTo(participantTab.snp.trailing).offset(-16)
                }
                self.writtenTab.isSelected = false
            })
            .disposed(by: disposeBag)
    }

    private var myInfoWithChevron = MyInfoViewWithChevron()

    private var writtenTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .selected)
        button.setTitleColor(.darkG25, for: .selected)
        button.setBackgroundColor(.clear, for: .selected)
        button.setTitle(L10n.MyPage.Tab.MyPost.title, for: .normal)
        button.setTitleColor(.darkG45, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody15R
    }

    private var participantTab = UIButton().then { button in
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .selected)
        button.setTitleColor(.darkG25, for: .selected)
        button.setBackgroundColor(.clear, for: .selected)
        button.setTitle(L10n.MyPage.Tab.MyParticipant.title, for: .normal)
        button.setTitleColor(.darkG45, for: .normal)
        button.setBackgroundColor(.clear, for: .normal)
        button.titleLabel?.font = .iosBody15R
    }

    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG55
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private var hMover = UIView().then { view in
        view.backgroundColor = .darkG25
        view.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }

    private lazy var myPostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BasicPostCell.self, forCellWithReuseIdentifier: BasicPostCell.id)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var myRunningCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AttendablePostCell.self, forCellWithReuseIdentifier: AttendablePostCell.id)
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        return collectionView
    }()

    private var myPostEmptyLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG45
        label.isHidden = true
        label.text = L10n.MyPage.MyPost.Empty.title
    }

    private var myPostEmptyButton = UIButton().then { button in
        button.setTitle(L10n.MyPage.MyPost.Empty.Button.title, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
    }

    private var myRunningEmptyLabel = UILabel().then { label in
        label.font = .iosTitle19R
        label.textColor = .darkG45
        label.isHidden = true
        label.text = L10n.MyPage.MyRunning.Empty.title
    }

    private var myRunningEmptyButton = UIButton().then { button in
        button.setTitle(L10n.MyPage.MyRunning.Empty.Button.title, for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = ""
        navBar.rightBtnItem.setImage(Asset.settings.uiImage, for: .normal)
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension MyPageViewController {
    private func setupViews() {
        gradientBackground()

        view.addSubviews([
            navBar,
            myInfoWithChevron,
            writtenTab,
            participantTab,
            hDivider,
            hMover,
            myPostCollectionView,
            myRunningCollectionView,
        ])

        myPostCollectionView.addSubviews([
            myPostEmptyLabel,
            myPostEmptyButton,
        ])

        myRunningCollectionView.addSubviews([
            myRunningEmptyLabel,
            myRunningEmptyButton,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        myInfoWithChevron.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        writtenTab.snp.makeConstraints { make in
            make.top.equalTo(myInfoWithChevron.snp.bottom).offset(36)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.centerX)
        }

        participantTab.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.top)
            make.leading.equalTo(view.snp.centerX)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(writtenTab.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        hMover.snp.makeConstraints { make in
            make.bottom.equalTo(hDivider.snp.bottom)
            make.leading.equalTo(writtenTab.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.centerX).offset(-16)
        }

        myPostCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        myRunningCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(2)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        myPostEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(myPostCollectionView.snp.centerX)
            make.bottom.equalTo(myPostCollectionView.snp.centerY).offset(-12)
        }

        myPostEmptyButton.snp.makeConstraints { make in
            make.centerX.equalTo(myPostCollectionView.snp.centerX)
            make.top.equalTo(myPostCollectionView.snp.centerY).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(220)
        }
        myPostEmptyButton.layer.cornerRadius = 20

        myRunningEmptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(myRunningCollectionView.snp.centerX)
            make.bottom.equalTo(myRunningCollectionView.snp.centerY).offset(-12)
        }

        myRunningEmptyButton.snp.makeConstraints { make in
            make.centerX.equalTo(myRunningCollectionView.snp.centerX)
            make.top.equalTo(myRunningCollectionView.snp.centerY).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(220)
        }
        myRunningEmptyButton.layer.cornerRadius = 20
    }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        switch collectionView {
        case let c where c == myRunningCollectionView:
            return AttendablePostCell.size
        case let c where c == myPostCollectionView:
            return BasicPostCell.size
        default:
            return .zero
        }
    }
}
