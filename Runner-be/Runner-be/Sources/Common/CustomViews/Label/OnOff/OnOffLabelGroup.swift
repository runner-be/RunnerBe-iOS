//
//  OnOffLabelGroup.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/09.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

class OnOffLabelGroup {
    var result = [Int]()

    var styleOn = OnOffLabel.Style() {
        didSet {
            labels.forEach { $0.styleOn = styleOn }
        }
    }

    var styleOff = OnOffLabel.Style() {
        didSet {
            labels.forEach { $0.styleOff = styleOff }
        }
    }

    var selected: [Int] {
        for (idx, label) in labels.enumerated() {
            if label.isOn {
                if result.isEmpty {
                    result.append(idx)
                } else {
                    result[0] = idx
                }
            }
        }
        return result
    }

    var maxNumberOfOnState = 1 {
        didSet {
            _ = labels.reduce(Int(0)) { numberOfOnState, label in
                if label.isOn, numberOfOnState > maxNumberOfOnState {
                    label.isOn = false
                }
                return numberOfOnState + (label.isOn ? 1 : 0)
            }
        }
    }

    var tap = PublishSubject<Int>()

    private var disposeBag = DisposeBag()
    var labels = [OnOffLabel]()
    private var numberOfOnState = 0
    private var lastSelected: OnOffLabel?

    func append(labels: [OnOffLabel]) {
        labels.forEach {
            $0.styleOn = styleOn
            $0.styleOff = styleOff
            self.register(label: $0)
        }
    }

    private func register(label: OnOffLabel) {
        label.rx.tapGesture()
            .when(.recognized)
            .map { _ in label }
            .do(onNext: { [weak self] label in
                self?.toggle(label: label)
            })
            .subscribe(onNext: { [weak self] _ in
                self?.tap.onNext(self?.selected[0] ?? 0)
            })
            .disposed(by: disposeBag)
        labels.append(label)
    }

    func toggle(label: OnOffLabel) {
        if label.isOn {
            label.isOn = false
            numberOfOnState -= 1
            if lastSelected === label {
                lastSelected = nil
            }
            return
        } else {
            if maxNumberOfOnState <= numberOfOnState {
                lastSelected?.isOn = false
                numberOfOnState -= 1
            }
            label.isOn = true
            lastSelected = label
            numberOfOnState += 1
        }
    }
}

extension OnOffLabelGroup {
    func then(_ block: (OnOffLabelGroup) -> Void) -> OnOffLabelGroup {
        block(self)
        return self
    }
}
