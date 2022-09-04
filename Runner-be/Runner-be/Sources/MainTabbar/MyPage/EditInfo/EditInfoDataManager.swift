//
//  EditInfoDataManager.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/22.
//

import Alamofire
import Foundation

class EditInfoDataManager {
    func getMyPage(viewController: EditInfoViewController) {
        AF.request("\(Constant.BASE_URL)users/\(UserDefaults.standard.integer(forKey: "userID"))/myPage/v2", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
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
        AF.request("\(Constant.BASE_URL)users/\(UserDefaults.standard.integer(forKey: "userID"))/job", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: Constant.HEADERS)
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
