//
//  MemberEndpoints.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import Foundation
import Moya

enum MemberEndpoints {
    // Get
    case getMember
    case getMyPosts
    case getMyComments
    case getLikedPosts
    
    // Patch
    case patchMember(data: MemberPatchRequestDTO)
}

extension MemberEndpoints: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.memberURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getMember:
            return ""
        case .getMyPosts:
            return "/my-posts"
        case .getMyComments:
            return "/my-comments"
        case .getLikedPosts:
            return "/liked-posts"
        case .patchMember:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchMember:
            return .patch
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMember, .getMyPosts, .getLikedPosts, .getMyComments:
            return .requestPlain
        case .patchMember(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json",
            "accept": "*/*"
        ]
    }
    
}


