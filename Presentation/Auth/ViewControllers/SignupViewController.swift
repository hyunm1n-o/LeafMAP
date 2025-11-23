//
//  SignupViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SignupViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    
    // MARK: - View
    private lazy var signupView = SignupView().then {
        $0.nextButton.addTarget(self, action: #selector(goToSelectMajor), for: .touchUpInside)
    }
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signupView)
        
        signupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setupTextFieldObservers() // 실시간 입력 감지 연결
        updateNextButtonState()   // 초기 버튼 상태 설정
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //MARK: - Functional
    //MARK: - Validation
    private func isValidId(_ id: String) -> Bool {
        let regex = "^[A-Za-z]+$"
        return !id.isEmpty && NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: id)
    }

    private func isValidStudentId(_ studentId: String) -> Bool {
        let expectedLength = 10 // 예시: 2022305053
        let regex = "^[0-9]{\(expectedLength)}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: studentId)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    // MARK: - Update Button State
    // MARK: - Update Button State
    private func updateNextButtonState() {
        let id = signupView.idTextField.getText()
        let studentId = signupView.stuNumTextField.getText()
        let password = signupView.passwordTextField.getText()
        let confirmPassword = signupView.checkPasswordTextField.getText()
        
        let isFormValid = isValidId(id) &&
                          isValidStudentId(studentId) &&
                          isValidPassword(password) &&
                          password == confirmPassword && !confirmPassword.isEmpty
        
        signupView.nextButton.setButtonState(
            isEnabled: isFormValid,
            enabledColor: .green01,
            disabledColor: .disable,
            enabledTitleColor: .white,
            disabledTitleColor: .white
        )
    }

    // MARK: - TextField Observers
    private func setupTextFieldObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: UITextField.textDidChangeNotification,
            object: nil
        )
    }

    @objc
    private func textFieldDidChange() {
        updateNextButtonState()
        
        // 아이디 검증
        let id = signupView.idTextField.getText()
        if id.isEmpty {
            signupView.idTextField.showError(message: "아이디를 입력해주세요")
        } else if !isValidId(id) {
            signupView.idTextField.showError(message: "아이디는 영문만 가능합니다")
        } else {
            signupView.idTextField.hideError()
        }
        
        // 학번 검증
        let studentId = signupView.stuNumTextField.getText()
        if studentId.isEmpty {
            signupView.stuNumTextField.showError(message: "학번을 입력해주세요")
        } else if !isValidStudentId(studentId) {
            signupView.stuNumTextField.showError(message: "학번은 10자리 숫자만 가능합니다")
        } else {
            signupView.stuNumTextField.hideError()
        }
        
        // 비밀번호 검증
        let password = signupView.passwordTextField.getText()
        if password.isEmpty {
            signupView.passwordTextField.showError(message: "비밀번호를 입력해주세요")
        } else if !isValidPassword(password) {
            signupView.passwordTextField.showError(message: "비밀번호는 8자 이상이어야 합니다")
        } else {
            signupView.passwordTextField.hideError()
        }
        
        // 비밀번호 확인 검증
        let confirmPassword = signupView.checkPasswordTextField.getText()
        if confirmPassword.isEmpty {
            signupView.checkPasswordTextField.showError(message: "비밀번호 확인을 입력해주세요")
        } else if confirmPassword != password {
            signupView.checkPasswordTextField.showError(message: "비밀번호가 일치하지 않습니다")
        } else {
            signupView.checkPasswordTextField.hideError()
        }
    }

    // MARK: - 버튼 클릭 시 검증
    @objc
    private func goToSelectMajor() {
        let id = signupView.idTextField.getText()
        let studentId = signupView.stuNumTextField.getText()
        let password = signupView.passwordTextField.getText()
        let confirmPassword = signupView.checkPasswordTextField.getText()
        
        var hasError = false
        
        if !isValidId(id) {
            hasError = true
            signupView.idTextField.showError(message: "아이디는 영문만 가능합니다")
        }
        
        if !isValidStudentId(studentId) {
            hasError = true
            signupView.stuNumTextField.showError(message: "학번은 10자리 숫자만 가능합니다")
        }
        
        if !isValidPassword(password) {
            hasError = true
            signupView.passwordTextField.showError(message: "비밀번호는 8자 이상이어야 합니다")
        }
        
        if confirmPassword.isEmpty {
            hasError = true
            signupView.checkPasswordTextField.showError(message: "비밀번호 확인을 입력해주세요")
        } else if confirmPassword != password {
            hasError = true
            signupView.checkPasswordTextField.showError(message: "비밀번호가 일치하지 않습니다")
        }
        
        updateNextButtonState()
        
        if hasError { return }

        // 다음 화면으로 데이터 전달
        let nextVC = SelectMajorViewController()
        nextVC.loginId = id
        nextVC.studentId = studentId
        nextVC.password = password
        navigationController?.pushViewController(nextVC, animated: true)
    }

    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Setup UI
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )

        navigationBarManager.setTitle(
            to: navigationItem,
            title: "회원가입",
            textColor: .gray900
        )

        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
