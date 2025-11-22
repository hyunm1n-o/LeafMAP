//
//  ViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/19/25.
//

import UIKit

class MainLoginViewController: UIViewController {
    // MARK: - Properties

    // MARK: - View
    private lazy var mainLoginView = MainLoginView().then {
        $0.signupButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        $0.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainLoginView)
        
        mainLoginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupTextFieldObservers()
        updateLoginButtonState() // 초기 상태 설정
    }
    
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.isNavigationBarHidden = true // 뷰 컨트롤러가 나타날 때 숨기기
    }

    override func viewWillDisappear(_ animated: Bool) {
      navigationController?.isNavigationBarHidden = false // 뷰 컨트롤러가 사라질 때 나타내기
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Functional
    //MARK: Event
    //MARK: - Setup
    private func setupTextFieldObservers() {
        // TextField 변경 감지
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: UITextField.textDidChangeNotification,
            object: nil
        )
    }
    
    //MARK: - Validation
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    private func updateLoginButtonState() {
        let id = mainLoginView.idTextField.getText()
        let password = mainLoginView.passwordTextField.getText()
        
        let isPasswordValid = isValidPassword(password)
        
        let isFormValid = !id.isEmpty && isPasswordValid
        
        mainLoginView.loginButton.setButtonState(
            isEnabled: isFormValid,
            enabledColor: .green01,
            disabledColor: .disable,
            enabledTitleColor: .white,
            disabledTitleColor: .white
        )
    }
    
    //MARK: - Event
    @objc
    private func textFieldDidChange() {
        updateLoginButtonState()
        
        // 실시간 에러 표시
        let id = mainLoginView.idTextField.getText()
        let password = mainLoginView.passwordTextField.getText()
        
        // 이메일 글자수 검증
        if id.isEmpty {
            mainLoginView.idTextField.showError(message: "아이디 또는 학번을 입력해 주세요")
        } else {
            mainLoginView.idTextField.hideError()
        }
        
        // 비밀번호 글자수 검증
        if !password.isEmpty && !isValidPassword(password) {
            mainLoginView.passwordTextField.showError(message: "비밀번호는 8자 이상 입력해주세요")
        } else {
            mainLoginView.passwordTextField.hideError()
        }
    }
    
    @objc
    private func loginButtonTapped() {
        let id = mainLoginView.idTextField.getText()
        let password = mainLoginView.passwordTextField.getText()
        
        var hasError = false
        
        // 아이디 검증
        if id.isEmpty {
            mainLoginView.idTextField.showError(message: "아이디 또는 학번을 입력해 주세요")
            hasError = true
        } else {
            mainLoginView.idTextField.hideError()
        }
        
        // 비밀번호 검증
        if password.isEmpty {
            mainLoginView.passwordTextField.showError(message: "비밀번호를 입력해 주세요")
            hasError = true
        } else if !isValidPassword(password) {
            mainLoginView.passwordTextField.showError(message: "비밀번호는 8자 이상 입력해주세요")
            hasError = true
        } else {
            mainLoginView.passwordTextField.hideError()
        }
        
        // 버튼 활성화 상태 업데이트
        updateLoginButtonState()
        
        // 에러 있으면 종료
        if hasError { return }
        
        // 로그인 처리
        print("✅ 로그인 성공!")
        print("아이디: \(id)")
        print("비밀번호: \(password)")
        
        // TODO: 로그인 API 호출
        let homeVC = HomeViewController()
        let nav = UINavigationController(rootViewController: homeVC)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }

    
    @objc
    private func goToSignUp() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
