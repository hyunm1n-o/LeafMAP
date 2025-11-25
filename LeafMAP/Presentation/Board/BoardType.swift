//
//  BoardType.swift
//  LeafMAP
//
//  Created by 오현민 on 11/24/25.
//

import Foundation

enum BoardType: String {
    case restaurant = "RESTAURANT"
    case shortcuts = "SHORTCUTS"
    case facilityUsage = "FACILITY_USAGE"
    case majorTips = "MAJOR_TIPS"
    case campusLifeTips = "CAMPUS_LIFE_TIPS"
    
    // 한글 이름 → 영문 API 타입 변환
    static func fromKoreanName(_ name: String) -> String {
        switch name {
        case "맛집 게시판":
            return BoardType.restaurant.rawValue
        case "지름길 보기":
            return BoardType.shortcuts.rawValue
        case "시설 이용하기":
            return BoardType.facilityUsage.rawValue
        case "학과 선택 꿀팁":
            return BoardType.majorTips.rawValue
        case "학교 생활 꿀팁":
            return BoardType.campusLifeTips.rawValue
        default:
            return BoardType.restaurant.rawValue // 기본값
        }
    }
    
    // 영문 API 타입 → 한글 이름 변환 (필요시)
    var koreanName: String {
        switch self {
        case .restaurant:
            return "맛집 게시판"
        case .shortcuts:
            return "지름길 보기"
        case .facilityUsage:
            return "시설 이용하기"
        case .majorTips:
            return "학과 선택 꿀팁"
        case .campusLifeTips:
            return "학교 생활 꿀팁"
        }
    }
}
