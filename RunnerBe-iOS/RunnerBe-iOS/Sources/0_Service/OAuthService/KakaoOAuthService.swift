//
//  KakaoOAuthService.swift
//  RunnerBe-iOS
//
//  Created by 김신우 on 2022/02/04.
//

import Foundation
import KakaoSDKCommon

class KakaoOAuthService {
    
    init() {
        KakaoSDK.initSDK(appKey: APIKeys.KakaoKey)
    }
}
