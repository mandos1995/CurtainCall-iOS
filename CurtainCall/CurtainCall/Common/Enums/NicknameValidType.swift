//
//  NicknameValidType.swift
//  CurtainCall
//
//  Created by 김민석 on 2023/07/07.
//

import Foundation

enum NicknameValidType {
    case success
    case blank
    case length
    case invalidForm
    case isDuplicated
    
    var message: String {
        switch self {
        case .success:
            return "유효한 닉네임 입니다."
        case .blank:
            return "공백이 포함되어 있습니다."
        case .length:
            return "최소 6자에서 최대 15자 이하로 작성해주세요."
        case .invalidForm:
            return "한글, 영문, 숫자만 가능합니다."
        case .isDuplicated:
            return "중복된 닉네임 입니다."
        }
    }
}