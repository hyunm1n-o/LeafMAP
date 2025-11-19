//
//  SelectMajorView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SelectMajorView: UIView {
    //MARK: - Components
    private lazy var progressBar = UIImageView().then {
        $0.image = UIImage(named: "progress2")
        $0.contentMode = .scaleAspectFill
    }
    
    public let idTextField = TitleTextField(title: "닉네임", placeholder: "사용할 닉네임을 입력해 주세요")
    public let majorDropDown = DropDownButton(title: "현재 학과", placeholder: "현재 학과를 선택해 주세요")
    public let hopeMajorDropDown = DropDownButton(title: "희망 학과", placeholder: "희망 학과를 선택해 주세요")
    
    public lazy var loginButton = AppButton(title: "가입완료 하기")
    
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
        addSubviews([progressBar, idTextField, majorDropDown, hopeMajorDropDown, loginButton])
    }
    
    private func setConstraints() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(48)
            $0.leading.equalToSuperview().inset(24)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(36)
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
        
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
    }
}
