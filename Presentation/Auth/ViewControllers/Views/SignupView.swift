//
//  SignupView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SignupView: UIView {
    //MARK: - Components
    private lazy var progressBar = UIImageView().then {
        $0.image = UIImage(named: "progress1")
        $0.contentMode = .scaleAspectFill
    }
    
    public let idTextField = TitleTextField(title: "아이디", placeholder: "사용할 아이디를 입력해 주세요")
    public let stuNumTextField = TitleTextField(title: "학번", placeholder: "학번을 입력해 주세요")
    public let passwordTextField = TitleTextField(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요").then {
        $0.setSecureTextEntry(true)
    }
    public let checkPasswordTextField = TitleTextField(title: "비밀번호 확인", placeholder: "비밀번호를 다시 입력해 주세요").then {
        $0.setSecureTextEntry(true)
    }
    
    public lazy var nextButton = AppButton(title: "다음으로")
    
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
        addSubviews([progressBar, idTextField, stuNumTextField, passwordTextField, checkPasswordTextField, nextButton])
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
        
        stuNumTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(stuNumTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)

        }
        
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
    }
}
