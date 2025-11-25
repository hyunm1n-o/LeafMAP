//
//  EditInfoView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class EditInfoView: UIView {
    //MARK: - Components
    public let idTextField = TitleTextField(title: "닉네임", placeholder: "변경할 닉네임을 입력해 주세요").then {
        $0.textField.keyboardType = .alphabet
    }
    public let majorDropDown = DropDownButton(title: "현재 학과", placeholder: "현재 학과를 선택해 주세요")
    public let hopeMajorDropDown = DropDownButton(title: "희망 학과", placeholder: "희망 학과를 선택해 주세요")
    
    public lazy var nextButton = AppButton(title: "수정하기")
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([idTextField, majorDropDown, hopeMajorDropDown, nextButton])
    }
    
    private func setConstraints() {
        idTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(36)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        majorDropDown.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        hopeMajorDropDown.snp.makeConstraints {
            $0.top.equalTo(majorDropDown.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)

        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
    }
}
