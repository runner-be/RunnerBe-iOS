//
//  EditInfoDataManager.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/22.
//

import Alamofire
import Foundation

class EditInfoDataManager {
    var userId = UserInfo().userId

    func getMyPage(viewController: EditInfoViewController) {
        AF.request("\(Constant.BASE_URL)users/\(userId)/myPage/v2", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: UserInfo().headers)
            .validate()
            .responseDecodable(of: GetMyPageResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        print(response)
                        viewController.didSuccessGetUserMyPage(response.result!)
                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }

    func patchJob(viewController: EditInfoViewController, job: String) {
        let parameters = PatchJobRequest(job: job)
        AF.request("\(Constant.BASE_URL)users/\(userId)/job", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: UserInfo().headers)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessPatchJob(response)

                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }
}
