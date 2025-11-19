//
//  SelectMajorViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SelectMajorViewController: UIViewController {
    
    //MARK: - Properties
    private let selectMajorView = SelectMajorView()
    
    private let majors = [
        "컴퓨터공학과",
        "전자공학과",
        "기계공학과",
        "경영학과",
        "경제학과",
        "심리학과",
        "디자인학과",
        "건축학과",
        "화학공학과",
        "수학과"
    ]

    override func loadView() {
        self.view = selectMajorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
        setupActions()
    }
    
    private func setupDropDowns() {
        // 드롭다운 옵션 설정
        selectMajorView.majorDropDown.setOptions(majors)
        selectMajorView.hopeMajorDropDown.setOptions(majors)
        
        // 현재 학과 선택 이벤트
        selectMajorView.majorDropDown.onSelect = { [weak self] selected, index in
            print("현재 학과 선택: \(selected)")
        }
        
        // 희망 학과 선택 이벤트
        selectMajorView.hopeMajorDropDown.onSelect = { [weak self] selected, index in
            print("희망 학과 선택: \(selected)")
        }
    }
    
    private func setupActions() {
        selectMajorView.loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func loginButtonTapped() {
        // 유효성 검사
        let nickname = selectMajorView.idTextField.getText()
        let currentMajor = selectMajorView.majorDropDown.getSelectedText()
        let hopeMajor = selectMajorView.hopeMajorDropDown.getSelectedText()
        
        // 닉네임 검증
        if nickname.isEmpty {
            selectMajorView.idTextField.showError(message: "닉네임을 입력해주세요")
            return
        }
        
        // 현재 학과 검증
        if currentMajor == nil {
            selectMajorView.majorDropDown.showError(message: "현재 학과를 선택해주세요")
            return
        }
        
        // 희망 학과 검증
        if hopeMajor == nil {
            selectMajorView.hopeMajorDropDown.showError(message: "희망 학과를 선택해주세요")
            return
        }
        
        // 모든 검증 통과
        print("✅ 가입 완료!")
        print("닉네임: \(nickname)")
        print("현재 학과: \(currentMajor!)")
        print("희망 학과: \(hopeMajor!)")
        
        // 여기서 회원가입 API 호출 등 처리
    }
}
