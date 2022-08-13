//
//  EditInfoViewModel.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/27.
//
import Foundation
import RxSwift

final class EditInfoViewModel: BaseViewModel {
    var dirty: Bool = false

    init(user: User, userAPIService: UserAPIService = BasicUserAPIService()) {
        super.init()

        Observable<String>.of(user.job)
            .map { Job(name: $0) }
            .filter { $0 != .none }
            .subscribe(onNext: { [weak self] job in
                self?.outputs.currentJob.onNext(job)
            })
            .disposed(by: disposeBag)

        inputs.nickNameText
            .subscribe(onNext: { [weak self] text in
                // 영어 소문자, 한글, 숫자
                let ruleOK = text.count > 0 && text.match(with: "[가-힣a-z0-9]{2,8}")
//                print(ruleOK)
                self?.outputs.nickNameRuleOK.onNext(ruleOK)
//                self?.outputs.nickNameDup.onNext(false)    //버튼을 눌렀을 때 중복확인을 해야하므로 여기서 처리X
            })
            .disposed(by: disposeBag)

//        inputs.jobSelected
//            .map { Job(idx: $0) }
//            .do(onNext: { [weak self] job in
//                if job == .none {
//                    self?.outputs.toast.onNext("오류가 발생했습니다 다시 시도해주세요")
//                }
//            })
//            .filter { $0 != .none }
//            .bind(to: routes.jobModal)
//            .disposed(by: disposeBag)

        inputs.backward
            .map { [weak self] in self?.dirty ?? true }
            .subscribe(routes.backward)
            .disposed(by: disposeBag)

        inputs.nickNameApply
            .map { _ in }
            .bind(to: routes.nickNameModal)
            .disposed(by: disposeBag)

        Observable.zip(inputs.nickNameApply, routeInputs.changeNickName) { (name: $0, ok: $1) }
            .filter { $0.ok }
            .flatMap { userAPIService.setNickName(to: $0.name) }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case let .succeed(name):
                    self?.outputs.nickNameChanged.onNext(name)
                    self?.outputs.toast.onNext("닉네임 변경이 완료되었습니다.")
                    self?.dirty = true
                case .duplicated:
                    self?.outputs.nickNameDup.onNext(true)
                case .alreadyChanged:
                    self?.outputs.nickNameAlreadyChanged.onNext(true)
                case .error:
                    self?.outputs.toast.onNext("닉네임 변경중 오류가 발생했습니다.")
                }
            })
            .disposed(by: disposeBag)
    }

    struct Input {
        var backward = PublishSubject<Void>()
        var nickNameText = PublishSubject<String>()
        var nickNameApply = PublishSubject<String>()
        var jobSelected = PublishSubject<String>()
    }

    struct Output {
        var currentJob = ReplaySubject<Job>.create(bufferSize: 1)

        var jobChanged = PublishSubject<Job>()

        var nickNameChanged = PublishSubject<String>()
        var nickNameDup = PublishSubject<Bool>()
        var nickNameRuleOK = PublishSubject<Bool>()
        var nickNameAlreadyChanged = PublishSubject<Bool>()

        var toast = PublishSubject<String>()
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
