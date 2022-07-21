//
//  SettingsDataManager.swift
//  Runner-be
//
//  Created by 이유리 on 2022/07/20.
//

import Alamofire
import Foundation

class SettinsDataManager {
    func getMyPage(viewController: SettingsViewController) {
        AF.request("\(Constant.BASE_URL)users/\(UserDefaults.standard.integer(forKey: "userID"))/myPage/v2", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetMyPageResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
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

    func patchPushOn(viewController: SettingsViewController, pushOn: String) {
        AF.request("\(Constant.BASE_URL)users/\(UserDefaults.standard.integer(forKey: "userID"))/push-alarm/\(pushOn)", method: .patch, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
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
