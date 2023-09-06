//
//  EditInfoViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//
import Foundation
import RxSwift

final class EditInfoViewModel: BaseViewModel {
    private let userUseCase = UserUseCase()

    var dirty: Bool = false
    var user: User

    var userJobCode = ""
    var userJobIdx = -1

    var selectedJobCode = "" // 선택된 jobcode
    var selectedJobIdx = -1 // 선택된 jobindex

    init(user: User) {
        self.user = user
        userJobCode = Job(name: user.job).code
        userJobIdx = Job(name: user.job).index

        super.init()

        requestDataToUseCase()
        uiBusinessLogic()
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var nickNameText = PublishSubject<String>()
        var nickNameApply = PublishSubject<String>()
        var jobSelected = PublishSubject<Void>()
    }

    struct Output {
        var currentJob = PublishSubject<Job>()
        var jobChanged = PublishSubject<Bool>()
        var nickNameChanged = PublishSubject<String>()
        var nickNameDup = PublishSubject<Bool>()
        var nickNameRuleOK = PublishSubject<Bool>()
        var nickNameAlreadyChanged = PublishSubject<Bool>()
        var toastActivity = PublishSubject<Bool>()
    }

    struct Route {
        var backward = PublishSubject<Bool>()
        var nickNameModal = PublishSubject<Void>()
        var jobModal = PublishSubject<Void>()
        var jobSelected = PublishSubject<String>()
    }

    struct RouteInput {
        var changeJob = PublishSubject<Bool>()
        var changeNickName = PublishSubject<Bool>()
    }

    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routes = Route()
    var routeInputs = RouteInput()
}

extension EditInfoViewModel {
    func requestDataToUseCase() {
        routeInputs.changeJob
            .filter { $0 }
            .flatMap { _ in self.userUseCase.setJob(to: Job(code: self.selectedJobCode)) }
            .subscribe(onNext: { isSuccess in
                switch isSuccess {
                case true:
                    self.dirty = true
                    self.outputs.jobChanged.onNext(true)
                case false:
                    self.toast.onNext("오류가 발생했습니다. 다시 시도해주세요")
                }
            })
            .disposed(by: disposeBag)

        Observable.zip(inputs.nickNameApply, routeInputs.changeNickName) { (name: $0, ok: $1) }
            .filter { $0.ok }
            .flatMap { self.userUseCase.setNickName(to: $0.name) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .succeed(name):
                    self?.outputs.nickNameChanged.onNext(name)
                    self?.toast.onNext("닉네임 변경이 완료되었습니다.")
                    self?.dirty = true
                case .duplicated:
                    self?.outputs.nickNameDup.onNext(true)
                case .alreadyChanged:
                    self?.outputs.nickNameAlreadyChanged.onNext(true)
                case .error:
                    self?.toast.onNext("닉네임 변경중 오류가 발생했습니다.")
                }
            })
            .disposed(by: disposeBag)
    }

    func uiBusinessLogic() {
        inputs.nickNameText
            .subscribe(onNext: { [weak self] text in
                // 영어 소문자, 한글, 숫자
                let ruleOK = text.count > 0 && text.match(with: "[가-힣a-z0-9]{2,8}")
                self?.outputs.nickNameRuleOK.onNext(ruleOK)
            })
            .disposed(by: disposeBag)

        inputs.jobSelected
            .subscribe(onNext: {
                self.routes.jobModal.onNext(())
            })
            .disposed(by: disposeBag)

        inputs.backward
            .map { [weak self] in self?.dirty ?? true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.nickNameApply
            .map { _ in }
            .bind(to: routes.nickNameModal)
            .disposed(by: disposeBag)
    }
}
