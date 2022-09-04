//
//  ManageAttendanceDataManager.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/13.
//

import Alamofire
import Foundation

class ManageAttendanceDataManager {
    func getManageAttendance(viewController: ManageAttendanceViewController) {
        AF.request("\(Constant.BASE_URL)users/\(UserDefaults.standard.integer(forKey: "userID"))/myPage/v2", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: GetMyPageResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessGetManageAttendance(result: response.result!)
                    } else {
                        viewController.failedToRequest(message: response.message)
                    }
                case let .failure(error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                }
            }
    }

    func patchAttendance(viewController: ManageAttendanceViewController, postId: Int, userIdList: String, whetherAttendList: String) {
        let parameters = PatchAttendanceRequest(userIdList: userIdList, whetherAttendList: whetherAttendList)
        AF.request("\(Constant.BASE_URL)runnings/\(postId)/attend", method: .patch, parameters: parameters, encoder: JSONParameterEncoder(), headers: Constant.HEADERS)
            .validate()
            .responseDecodable(of: BaseResponse.self) { response in
                switch response.result {
                case let .success(response):
                    if response.isSuccess {
                        viewController.didSuccessPatchAttendance(response)

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
