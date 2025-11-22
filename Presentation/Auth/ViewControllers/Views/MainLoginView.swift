//
//  MainLoginView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit
import Then
import SnapKit

class MainLoginView: UIView {
    //MARK: - Properties
    
    //MARK: - Components
    private lazy var title = AppLabel(text: "풀잎맵🌱",
                                      font: UIFont(name: AppFontName.pSemiBold, size: 32)!,
                                      textColor: .gray900).then {
        let targetString = "풀잎"
        $0.asColor(targetString: targetString, color: .green02)
        $0.textAlignment = .left
    }
    
    private lazy var sub = AppLabel(text: "풀잎맵과 함께, 더 가까워지는 서경생활",
                                    font: UIFont(name: AppFontName.pMedium, size: 16)!,
                                    textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    public lazy var idTextField = AppTextField(iconName: "ID", placeholder: "아이디 및 학번을 입력해 주세요")
    public lazy var passwordTextField = AppTextField(iconName: "Password", placeholder: "비밀번호를 입력해 주세요").then {
        $0.setSecureTextEntry(true)
    }
    
    public lazy var loginButton = AppButton(title: "로그인")
    public lazy var signupButton = SmallTextButton(title: "회원가입")
    
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
        addSubviews([title, sub, idTextField, passwordTextField, loginButton, signupButton])
    }
    
    private func setConstraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(149)
            $0.leading.equalToSuperview().inset(24)
        }
        
        sub.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(44)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(93)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }

}
