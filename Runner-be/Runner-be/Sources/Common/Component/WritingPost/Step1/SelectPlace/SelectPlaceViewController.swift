//
//  SelectPlaceViewController.swift
//  Runner-be
//
//  Created by 김창규 on 8/20/24.
//

import MapKit
import RxDataSources
import RxSwift
import Then
import UIKit

final class SelectPlaceViewController: BaseViewController {
    // MARK: - Properties

    // 주소검색
    private var searchCompleter: MKLocalSearchCompleter? // 검색을 도와주는 변수
    private var searchRegion: MKCoordinateRegion = .init(MKMapRect.world) // 검색 지역 범위를 결정하는 변수
    var completerResults: [MKLocalSearchCompletion]? // 검색한 결과를 담는 변수
    private var places: MKMapItem? { // collectionView에서 선택한 Location의 정보를 담는 변수
        didSet {
            selectPlaceResultsView.resultCollectionView.reloadData()
        }
    }

    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }

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

        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .pointOfInterest
        searchCompleter?.region = searchRegion
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil
    }

    // MARK: - Methods

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .debug()
            .bind(to: viewModel.routes.cancel)
            .disposed(by: disposeBag)

        searchBarView.cancelButton.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                searchBarView.textField.text = ""
                searchBarView.textField.sendActions(for: .editingChanged)
            }.disposed(by: disposeBag)

        searchBarView.textField.rx.text
            .bind { [weak self] inputText in
                guard let self = self,
                      let inputText = inputText,
                      inputText != ""
                else {
                    self?.selectPlaceGuideView.isHidden = false
                    self?.selectPlaceResultsView.isHidden = true
                    self?.selectPlaceEmptyView.isHidden = true
                    self?.completerResults = nil
                    self?.searchCompleter?.queryFragment = ""
                    return
                }
                selectPlaceGuideView.isHidden = true
                selectPlaceResultsView.isHidden = false
                searchCompleter?.queryFragment = inputText
            }.disposed(by: disposeBag)

        selectPlaceResultsView.resultCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapPlace)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        selectPlaceResultsView.resultCollectionView.rx.setDelegate(self).disposed(by: disposeBag)

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

extension SelectPlaceViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        viewModel.inputs.completerResults.onNext(completer.results)
        selectPlaceEmptyView.isHidden = !(completerResults?.isEmpty ?? false)
    }

    func completer(_: MKLocalSearchCompleter, didFailWithError error: any Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error : \(error.localizedDescription)")
        }
    }
}

extension SelectPlaceViewController: UICollectionViewDelegate,
    UIScrollViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return SelectPlaceResultCell.size
    }

    func scrollViewDidScroll(_: UIScrollView) {
        view.endEditing(true)
    }
}
