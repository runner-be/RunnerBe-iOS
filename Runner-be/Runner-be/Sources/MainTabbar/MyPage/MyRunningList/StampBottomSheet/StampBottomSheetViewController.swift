//
//  StampBottomSheetViewController.swift
//  Runner-be
//
//  Created by 김창규 on 9/2/24.
//

import RxDataSources
import UIKit

final class StampBottomSheetViewController: BaseViewController {
    // MARK: - Properties

    private let viewModel: StampBottomSheetViewModel

    // MARK: - UI

    private let backgroundView = UIView()

    private let bottomSheetBg = UIView().then {
        $0.backgroundColor = .darkG55
        $0.layer.cornerRadius = 12
    }

    private let bottomHandle = UIView().then {
        $0.backgroundColor = .darkG6
        $0.layer.cornerRadius = 1.5
    }

    private let titleLabel = UILabel().then {
        $0.text = "날씨"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold20
        $0.textAlignment = .left
    }

    private lazy var stampCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        var collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            LogStampCell.self,
            forCellWithReuseIdentifier: LogStampCell.id
        )
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 0)

        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let stampTitleLabel = UILabel().then {
        $0.text = "Stamp Title"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold20
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let stampSubTitleLabel = UILabel().then {
        $0.text = "Stamp SubTitle"
        $0.textColor = .darkG35
        $0.font = .pretendardRegular16
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.isHidden = true
    }

    private let tempView = UIView()
    private let tempTitleLabel = UILabel().then {
        $0.text = "기온"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold20
        $0.textAlignment = .left
    }

    private let tempTextField = TextFieldWithPadding().then {
        $0.placeholder = "기온을 입력하세요!"
        $0.textPadding = .init(top: 11, left: 14, bottom: 11, right: 14)
        $0.backgroundColor = .white.withAlphaComponent(0.04)
        $0.layer.cornerRadius = 8
        $0.keyboardType = .numbersAndPunctuation
    }

    private let tempUnitLabel = UILabel().then {
        $0.text = "℃"
        $0.textColor = .darkG2
        $0.font = .pretendardSemiBold20
    }

    private let registerButton = UIButton().then {
        $0.backgroundColor = .primary
        $0.layer.cornerRadius = 24
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.darkG6, for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold16
    }

    // MARK: - Init

    init(viewModel: StampBottomSheetViewModel) {
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

        tempTextField.delegate = self

        // 키보드 이벤트를 감지하는 옵저버 추가
        dismissKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBottomSheet()
    }

    // MARK: - Methods

    @objc func keyboardWillShow(notification: NSNotification) {
        // 키보드 높이를 가져옴
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            // 현재 뷰의 프레임을 키보드 높이만큼 위로 이동
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardHeight
            }
        }
    }

    @objc func keyboardWillHide(notification _: NSNotification) {
        // 뷰를 원래 위치로 되돌림
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    private func viewModelInput() {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .bind(to: viewModel.routes.backward)
            .disposed(by: disposeBag)

        stampCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: viewModel.inputs.tapStamp)
            .disposed(by: disposeBag)

        tempTextField.rx.text
            .skip(1)
            .bind(to: viewModel.inputs.temperature)
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .bind(to: viewModel.inputs.register)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        stampCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        typealias LogStampDataSource = RxCollectionViewSectionedAnimatedDataSource<LogStampSection>

        let logStampDatasource = LogStampDataSource(
            configureCell: { [weak self] _, collectionView, indexPath, element -> UICollectionViewCell in
                guard let _ = self,
                      let cell = collectionView.dequeueReusableCell(
                          withReuseIdentifier: LogStampCell.id,
                          for: indexPath
                      ) as? LogStampCell
                else {
                    return UICollectionViewCell()
                }

                if let stampType = element.stampType {
                    cell.configure(
                        with: stampType,
                        isEnabled: element.isEnabled
                    )
                }
                return cell
            }
        )

        viewModel.outputs.logStamps
            .map { [LogStampSection(items: $0)] }
            .bind(to: stampCollectionView.rx.items(dataSource: logStampDatasource))
            .disposed(by: disposeBag)

        viewModel.outputs.selectedStamp
            .bind { [weak self] outputs in
                guard let self = self else { return }

                self.stampCollectionView.selectItem(
                    at: IndexPath(item: outputs.index, section: 0),
                    animated: true,
                    scrollPosition: .centeredHorizontally
                )
                self.stampTitleLabel.text = outputs.stampType.title
                self.stampSubTitleLabel.text = outputs.stampType.subTitle
            }.disposed(by: disposeBag)

        viewModel.outputs.selectedTemp
            .bind(to: tempTextField.rx.text)
            .disposed(by: disposeBag)
    }

    private func animateBottomSheet() {
        // Update the constraint to animate the bottom sheet coming up
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.bottomSheetBg.snp.updateConstraints {
                $0.top.equalTo(self.view.snp.bottom).offset(-369)
            }
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITextFieldDelegate

extension StampBottomSheetViewController: UITextFieldDelegate {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        // 숫자와 -만 허용
        let allowedCharacters = CharacterSet(charactersIn: "0123456789-")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: - UICollectionViewDelegate

extension StampBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        LogStampCell.size
    }
}

// MARK: - Layout

extension StampBottomSheetViewController {
    private func setupViews() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.addSubviews([
            backgroundView,
            bottomSheetBg,
        ])

        bottomSheetBg.addSubviews([
            bottomHandle,
            titleLabel,
            stampCollectionView,
            stampTitleLabel,
            stampSubTitleLabel,
            registerButton,
            tempView,
        ])

        tempView.addSubviews([
            tempTitleLabel,
            tempTextField,
            tempUnitLabel,
        ])
    }

    private func initialLayout() {
        backgroundView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }

        bottomSheetBg.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.bottom)
            $0.height.equalTo(385)
        }

        bottomHandle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(37)
            $0.height.equalTo(3)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bottomHandle.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(28)
        }

        stampCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(64)
        }

        stampTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stampCollectionView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        stampSubTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stampTitleLabel.snp.bottom).offset(8)
            $0.left.right.equalTo(stampTitleLabel)
            $0.height.equalTo(0)
        }

        tempView.snp.makeConstraints {
            $0.top.equalTo(stampCollectionView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        tempTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }

        tempTextField.snp.makeConstraints {
            $0.top.equalTo(tempTitleLabel.snp.bottom).offset(16)
            $0.left.bottom.equalToSuperview()
        }

        tempUnitLabel.snp.makeConstraints {
            $0.centerY.equalTo(tempTextField)
            $0.left.equalTo(tempTextField.snp.right).offset(8)
            $0.right.equalToSuperview()
        }

        registerButton.snp.makeConstraints {
            $0.top.equalTo(tempView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
}
