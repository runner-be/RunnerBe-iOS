//
//  SelectPlaceViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/20/24.
//

import RxDataSources
import RxSwift
import Then
import UIKit

final class SelectPlaceViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: SelectPlaceViewModel

    // MARK: - UI

    private var navBar = RunnerbeNavBar().then {
        $0.titleLabel.text = L10n.Post.Place.NavBar.title
        $0.leftBtnItem.setImage(Asset.x.uiImage.withTintColor(.darkG3), for: .normal)
    }

    private let searchBarView = SearchBarView(placeHolder: "모임 장소 검색").then {
        $0.layer.cornerRadius = 8
    }

    // [START] Set Current Location
    private let setCurrentLocationView = UIView()
    private let setCurrentLocationLabel = IconLabel(
        iconPosition: .left,
        iconSize: CGSize(width: 18, height: 18),
        spacing: 6,
        padding: .zero
    ).then {
        $0.icon.image = Asset.iconLocation18.uiImage
        $0.label.font = .pretendardRegular14
        $0.label.textColor = .darkG35
        $0.label.text = "현재 위치로 설정"
    }

    private let chevronRightIcon = UIImageView(image: Asset.chevronRight.uiImage)
    private var hDivider = UIView().then { view in
        view.backgroundColor = .darkG6
    }

    // [END] Set Current Location

    private let selectPlaceGuideView = SelectPlaceGuideView().then {
        $0.isHidden = false
    }

    private let selectPlaceEmptyView = SelectPlaceEmptyView().then {
        $0.isHidden = true
    }

    private let selectPlaceResultsView = SelectPlaceResultsView().then {
        $0.isHidden = true
    }

    // MARK: - Init

    init(viewModel: SelectPlaceViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
    }

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .debug()
            .bind(to: viewModel.routes.cancel)
            .disposed(by: disposeBag)

        selectPlaceResultsView.resultCollectionView.rx.itemSelected
            .map { $0.item }
            .bind { _ in
                print("selectPlaceReulst Item is Clicked")
            }.disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        typealias SelectPlaceDataSource = RxCollectionViewSectionedAnimatedDataSource<SelectPlaceListSection>

        let dataSource = SelectPlaceDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let _ = self,
                      let cell = collectionView.dequeueReusableCell(
                          withReuseIdentifier: SelectPlaceResultCell.id,
                          for: indexPath
                      ) as? SelectPlaceResultCell
                else {
                    return UICollectionViewCell()
                }

                cell.configure(
                    title: element.title,
                    subTitle: element.subTitle
                )

                return cell
            }
        )

        viewModel.outputs.placeList
            .debug()
            .map { [SelectPlaceListSection(items: $0)] }
            .bind(to: selectPlaceResultsView.resultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension SelectPlaceViewController {
    private func setupViews() {
        setBackgroundColor()
        view.addSubviews([
            navBar,
            searchBarView,
            setCurrentLocationView,
            selectPlaceGuideView,
            selectPlaceEmptyView,
            selectPlaceResultsView,
        ])

        setCurrentLocationView.addSubviews([
            setCurrentLocationLabel,
            chevronRightIcon,
            hDivider,
        ])
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        searchBarView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        setCurrentLocationView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        setCurrentLocationLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
        }

        chevronRightIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
            $0.size.equalTo(22)
        }

        hDivider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }

        selectPlaceGuideView.snp.makeConstraints {
            $0.top.equalTo(setCurrentLocationView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }

        selectPlaceEmptyView.snp.makeConstraints {
            $0.top.equalTo(setCurrentLocationView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }

        selectPlaceResultsView.snp.makeConstraints {
            $0.top.equalTo(setCurrentLocationView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
}
