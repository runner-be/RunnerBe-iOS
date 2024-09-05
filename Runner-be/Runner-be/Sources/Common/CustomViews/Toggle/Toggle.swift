//
//  Toggle.swift
//  Runner-be
//
//  Created by 김창규 on 9/5/24.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ToggleSwitch: UIView {
    // MARK: - Properties

    // 상태 변화를 방출하는 Observable
    var toggleObservable: Observable<Bool> {
        return toggleRelay.asObservable()
    }

    // 토글 상태 방출용 Relay
    private let toggleRelay = PublishRelay<Bool>()

    private var isOn: Bool = true {
        didSet {
            print("ToggleSwitch Status: \(isOn ? "ON" : "OFF")")
            toggleRelay.accept(isOn)
            updateUI()
        }
    }

    // MARK: - UI

    private let circle = UIView().then {
        $0.layer.cornerRadius = 9
        $0.backgroundColor = .white
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupViews()
        initialLayout()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSwitch)))
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggleSwitch() {
        isOn.toggle() // 토글 상태 변경
    }

    // 상태에 따른 UI 업데이트
    private func updateUI() {
        // 애니메이션을 사용해 토글 전환
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.isOn ? .primary : .darkG45

            self.circle.snp.remakeConstraints {
                if self.isOn {
                    $0.right.equalToSuperview().inset(3) // ON 상태
                } else {
                    $0.left.equalToSuperview().inset(3) // OFF 상태
                }
                $0.centerY.equalToSuperview()
                $0.size.equalTo(18)
            }
            self.layoutIfNeeded() // 레이아웃 업데이트
        }
    }
}

// MARK: - Layout

extension ToggleSwitch {
    private func setupViews() {
        backgroundColor = .primary
        layer.cornerRadius = 12

        addSubview(circle)
    }

    private func initialLayout() {
        circle.snp.makeConstraints {
            if isOn {
                $0.right.equalToSuperview().inset(3) // ON 상태: 오른쪽
            } else {
                $0.left.equalToSuperview().inset(3) // OFF 상태: 왼쪽
            }
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
}
