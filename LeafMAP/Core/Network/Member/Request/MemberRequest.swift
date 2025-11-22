//
//  MemberRequest.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import Foundation

struct MemberPatchRequestDTO: Codable {
    let nickname: String
    let major: String
    let desiredMajor: String
}
