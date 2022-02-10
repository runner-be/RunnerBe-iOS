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
        var result = [Int]()
        for (idx, _) in labels.enumerated() {
            result.append(idx)
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

    private var disposeBags = DisposeBag()
    private var labels = [OnOffLabel]()
    private var numberOfOnState = 0
    private var lastSelected: OnOffLabel?

    func append(labels: [OnOffLabel]) {
        labels.forEach {
            $0.styleOn = styleOn
            $0.styleOff = styleOff
            self.append(label: $0)
        }
    }

    private func append(label: OnOffLabel) {
        label.rx.tapGesture()
            .when(.recognized)
            .map { _ in label }
            .subscribe(onNext: { [weak self] label in
                self?.toggle(label: label)
            })
            .disposed(by: disposeBags)
    }

    private func toggle(label: OnOffLabel) {
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
