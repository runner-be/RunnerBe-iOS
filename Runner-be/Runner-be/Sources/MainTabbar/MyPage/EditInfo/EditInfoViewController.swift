//
//  EditInfoViewController.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//

import Kingfisher
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import UIKit

class EditInfoViewController: BaseViewController {
    var selectedJobCode = "" // 선택된 jobcode
    var selectedJobIdx = -1 // 선택된 jobindex

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()

        viewModelInput()
        viewModelOutput()
        viewInputs()
    }

    // TODO: 유저 이미지 연결
    init(viewModel: EditInfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var viewModel: EditInfoViewModel

    private func viewModelInput() {
        navBar.leftBtnItem.rx.tap
            .bind(to: viewModel.inputs.backward)
            .disposed(by: disposeBag)

        selectNickName.applyButton.rx.tap
            .compactMap { [unowned self] in self.selectNickName.nickNameField.text }
            .bind(to: viewModel.inputs.nickNameApply)
            .disposed(by: disposeBag)

        selectNickName.nickNameField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: viewModel.inputs.nickNameText)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel.outputs.nickNameDup // 닉네임 중복처리
            .subscribe(onNext: { [weak self] dup in
                self?.nickNameDupErrLabel.isHidden = !dup
                self?.selectNickName.applyButton.isEnabled = !dup
            })
            .disposed(by: disposeBag)

        viewModel.outputs.nickNameRuleOK // 유효성 검증
            .subscribe(onNext: { [weak self] ok in
                self?.nickNameRuleErrLabel.isHidden = ok
                self?.selectNickName.applyButton.isEnabled = ok
            })
            .disposed(by: disposeBag)

        viewModel.outputs.nickNameAlreadyChanged
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.nickNameGuideLabel.isHidden = false
                self?.nickNameRuleErrLabel.isHidden = true
                self?.nickNameDupErrLabel.isHidden = true
                self?.selectNickName.nickNameField.isEnabled = false
                self?.selectNickName.disableWithPlaceHolder(
                    fieldText: nil,

                    buttonText: L10n.MyPage.EditInfo.NickName.Button.cant
                )
            })
            .disposed(by: disposeBag)

        viewModel.outputs.nickNameChanged
            .subscribe(onNext: { [weak self] newName in
                self?.selectNickName.disableWithPlaceHolder(
                    fieldText: newName,
                    buttonText: L10n.MyPage.EditInfo.NickName.Button.NickNameChanged.title
                )
                self?.nickNameGuideLabel.text = L10n.MyPage.EditInfo.NickName.InfoLabel.alreadychanged
                self?.nickNameGuideLabel.isHidden = false
                self?.nickNameRuleErrLabel.isHidden = true
                self?.nickNameRuleErrLabel.isHidden = true
            })
            .disposed(by: disposeBag)

        viewModel.outputs.jobChanged
            .subscribe(onNext: { isSuccess in
                if isSuccess {
                    self.selectJobView.select(idx: self.selectedJobIdx)
                }
            })
            .disposed(by: disposeBag)

        viewModel.toast
            .subscribe(onNext: { message in
                AppContext.shared.makeToast(message)
            })
            .disposed(by: disposeBag)

        viewModel.toastActivity
            .subscribe(onNext: { show in
                if show {
                    AppContext.shared.makeToastActivity(position: .center)
                } else {
                    AppContext.shared.hideToastActivity()
                }
            })
            .disposed(by: disposeBag)
    }

    private func viewInputs() {
        selectNickName.nickNameField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.layer.borderWidth = 1
            })
            .disposed(by: disposeBag)

        selectNickName.nickNameField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)

        view.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] recognizer in
                guard let self = self else { return false }
                return !self.selectNickName.nickNameField.frame.contains(recognizer.location(in: self.view))
            }
            .subscribe(onNext: { [weak self] _ in
                self?.selectNickName.nickNameField.endEditing(true)
            })
            .disposed(by: disposeBag)

        selectJobView.jobGroup.tap
            .filter { numSelected in numSelected > 0 }
            .filter { _ in
                let idx = self.selectJobView.jobGroup.selected[0]

                if idx != self.viewModel.userJobIdx, self.viewModel.user.jobChangePossible! == "Y" { // 여기서 jobindx가 다르고, 직업 수정이 가능하다면 true를 넘김 -> 아래 가 실행이 되고
                    self.selectedJobIdx = idx
                    self.selectedJobCode = Job(idx: idx).code
                    return true
                } else if self.viewModel.user.jobChangePossible! == "N" { // jobindex는 다르나 직업 수정이 불가능하다면, 안내라벨 띄우기
                    self.selectJobGuideLabel.isHidden = false
                    return false
                } else {
                    return false
                }
            }
            .map { _ in self.selectedJobCode }
            .bind(to: viewModel.inputs.jobSelected)
            .disposed(by: disposeBag)
    }

    private lazy var selectNickName = TextFieldWithButton().then { view in
        view.titleLabel.text = L10n.MyPage.EditInfo.NickName.title
        view.applyButton.setTitle(L10n.MyPage.EditInfo.NickName.Button.apply, for: .normal)
        view.setPlaceHolder(to: L10n.MyPage.EditInfo.NickName.TextField.PlaceHolder.rule)
        view.nickNameField.delegate = self
    }

    private var nickNameGuideLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = L10n.MyPage.EditInfo.NickName.InfoLabel.caution
        label.isHidden = false
    }

    private var nickNameDupErrLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.MyPage.EditInfo.NickName.ErrorLabel.duplicated
        label.isHidden = true
    }

    private var nickNameRuleErrLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .errorlight
        label.text = L10n.MyPage.EditInfo.NickName.ErrorLabel.form
        label.isHidden = true
    }

    private lazy var vStack = UIStackView.make(
        with: [nickNameGuideLabel, nickNameDupErrLabel, nickNameRuleErrLabel],
        axis: .vertical,
        alignment: .leading,
        distribution: .equalSpacing,
        spacing: 4
    )

    private var hDivider = UIView().then { view in
        view.backgroundColor = .black
        view.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
    }

    private var selectJobView = SelectJobView().then { view in
        view.titleLabel.text = L10n.MyPage.EditInfo.Job.title
        view.isHidden = false
    }

    private var selectJobGuideLabel = UILabel().then { label in
        label.font = .iosBody13R
        label.textColor = .primary
        label.text = L10n.MyPage.EditInfo.Job.ErrorLabel.cannotIn3Month
        label.isHidden = true // 처음엔 노출 안되게
    }

    private var navBar = RunnerbeNavBar().then { navBar in
        navBar.titleLabel.text = L10n.MyPage.EditInfo.NavBar.title
        navBar.titleLabel.textColor = .darkG35
        navBar.titleLabel.font = .iosBody17Sb
        navBar.leftBtnItem.setImage(Asset.arrowLeft.uiImage.withTintColor(.darkG3), for: .normal)
        navBar.rightBtnItem.isHidden = true
        navBar.rightSecondBtnItem.isHidden = true
    }
}

// MARK: - Layout

extension EditInfoViewController {
    private func setupViews() {
        setBackgroundColor()

        view.addSubviews([
            navBar,
            selectNickName,
            vStack,
            hDivider,
            selectJobView,
            selectJobGuideLabel,
        ])

        selectJobView.select(idx: viewModel.userJobIdx)

        if viewModel.user.nameChanged == "Y" {
            nickNameGuideLabel.text = L10n.MyPage.EditInfo.NickName.InfoLabel.alreadychanged
            selectNickName.nickNameField.isEnabled = false
            selectNickName.applyButton.isEnabled = false
            selectNickName.applyButton.setTitle(L10n.MyPage.EditInfo.NickName.Button.NickNameChanged.title, for: .disabled)
        } else {
            nickNameGuideLabel.text = L10n.MyPage.EditInfo.NickName.InfoLabel.caution
            selectNickName.applyButton.setTitle(L10n.MyPage.EditInfo.NickName.Button.apply, for: .normal)
        }
    }

    private func initialLayout() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        selectNickName.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
        }

        vStack.snp.makeConstraints { make in
            make.top.equalTo(selectNickName.snp.bottom).offset(12)
            make.leading.equalTo(selectNickName.snp.leading)
            make.trailing.equalTo(selectNickName.snp.trailing)
        }

        hDivider.snp.makeConstraints { make in
            make.top.equalTo(vStack.snp.bottom).offset(27)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }

        selectJobView.snp.makeConstraints { make in
            make.top.equalTo(hDivider.snp.bottom).offset(24)
            make.leading.equalTo(selectNickName.snp.leading)
            make.trailing.equalTo(selectNickName.snp.trailing) // 세로의 0.4로 비율조정
        }

        selectJobGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(selectJobView.snp.bottom).offset(24)
            make.leading.equalTo(selectJobView.snp.leading)
        }
    }
}

// MARK: - UITextFieldDelegate Delegate

extension EditInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText)
        else { return false }

        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 8
    }
}
