//
//  PostEndPoing.swift
//  LeafMAP
//
//  Created by 오현민 on 11/23/25.
//

import Foundation
import Moya

enum PostEndPoint {
    // Get
    case getPostList(boardType: String, cursor: Int, limit: Int)
    case getPostDetail(boardType: String, postId: Int)
    case getREShome
    
    // Patch
    case patchPublish(data: MemberPatchRequestDTO, boardType: String, postId: Int)
    
    // Post
    case postBoardPosts
    case postBoardPostsLike
}

extension PostEndPoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.postURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPostList:
            return "/\(boardType)/posts"
        case .getPostDetail:
            return "/\(boardType)/posts/\(postId)"
        case .getREShome:
            return "/RESTAURANT/home"
        case .patchPublish:
            return "/\(boardType)/posts/\(postId)/publish"
        case .postBoardPosts:
            return "/\(boardType)/posts"
        case .postBoardPostsLike:
            return "/\(boardType)/posts/\(postId)/like"
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
}
