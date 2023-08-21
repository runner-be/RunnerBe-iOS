//
//  PatchAttendanceRequest.swift
//  Runner-be
//
//  Created by 이유리 on 2022/08/21.
//

struct PatchAttendanceRequest: Encodable {
    var userIdList: String
    var whetherAttendList: String
}
