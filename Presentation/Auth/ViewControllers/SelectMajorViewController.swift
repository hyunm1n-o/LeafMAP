import UIKit
class SelectMajorViewController: UIViewController {

    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    let justOneService = JustOneService()

    // 이전 화면에서 전달받은 데이터
    var loginId: String = ""
    var studentId: String = ""
    var password: String = ""

    // MARK: - View
    private lazy var selectMajorView = SelectMajorView()
    
    // MARK: - Data
    private let majors = [
        "소프트웨어학과",
        "금융정보공학과",
        "전자컴퓨터공학과",
        "나노화학생명공학과",
        "물류시스템공학과",
        "도시공학과",
        "아동청소년학과",
        "글로벌비즈니스어학부",
        "공공인재학부",
        "경영학부",
        "미래융합학부1",
        "미래융합학부2",
        "자유전공학부"
    ]

    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selectMajorView)
        selectMajorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setupDropDowns()
        setupActions()
        setupTextFieldObservers() // 실시간 감지
        updateNextButtonState()   // 초기 버튼 상태
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
    // MARK: - DropDown
    private func setupDropDowns() {
        selectMajorView.majorDropDown.setOptions(majors)
        selectMajorView.hopeMajorDropDown.setOptions(majors)
        
        selectMajorView.majorDropDown.onSelect = { [weak self] _, _ in
            self?.updateNextButtonState()
        }
        
        selectMajorView.hopeMajorDropDown.onSelect = { [weak self] _, _ in
            self?.updateNextButtonState()
        }
    }
    
    // MARK: - Actions
    private func setupActions() {
        selectMajorView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupTextFieldObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: UITextField.textDidChangeNotification,
            object: selectMajorView.idTextField
        )
    }
    
    @objc private func textFieldDidChange(_ notification: Notification) {
        updateNextButtonState()
    }
    
    // MARK: - 버튼 활성화 상태 갱신
    private func updateNextButtonState() {
        let nickname = selectMajorView.idTextField.getText()
        let currentMajor = selectMajorView.majorDropDown.getSelectedText()
        let hopeMajor = selectMajorView.hopeMajorDropDown.getSelectedText()
        
        let isFormValid = !nickname.isEmpty && currentMajor != nil && hopeMajor != nil
        
        selectMajorView.nextButton.setButtonState(
            isEnabled: isFormValid,
            enabledColor: .green01,
            disabledColor: .disable,
            enabledTitleColor: .white,
            disabledTitleColor: .white
        )
    }
    
    // MARK: - 버튼 클릭 시 검증
    @objc private func nextButtonTapped() {
        let nickname = selectMajorView.idTextField.getText()
        let currentMajor = selectMajorView.majorDropDown.getSelectedText()
        let hopeMajor = selectMajorView.hopeMajorDropDown.getSelectedText()
        
        var hasError = false
        
        if nickname.isEmpty {
            hasError = true
            selectMajorView.idTextField.showError(message: "닉네임을 입력해주세요")
        }
        
        if currentMajor == nil {
            hasError = true
            selectMajorView.majorDropDown.showError(message: "현재 학과를 선택해주세요")
        }
        
        if hopeMajor == nil {
            hasError = true
            selectMajorView.hopeMajorDropDown.showError(message: "희망 학과를 선택해주세요")
        }
        
        updateNextButtonState()

        if hasError { return }

        // 회원가입 API 호출
        callPostSignup(
            nickname: nickname,
            currentMajor: currentMajor!,
            hopeMajor: hopeMajor!
        )
    }

    // MARK: - Network
    private func callPostSignup(nickname: String, currentMajor: String, hopeMajor: String) {
        let signupRequest = JustOneSignupRequestDTO(
            loginId: loginId,
            password: password,
            nickname: nickname,
            studentId: studentId,
            major: currentMajor,
            desiredMajor: hopeMajor
        )

        justOneService.postSignup(data: signupRequest) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                print("✅ 회원가입 성공!")
                // 회원가입 성공 후 자동 로그인
                self.callPostLogin()

            case .failure(let error):
                print("❌ 회원가입 실패: \(error.localizedDescription)")
                // 에러 처리
                if case .serverError(_, let message) = error {
                    self.showAlert(message: message)
                } else {
                    self.showAlert(message: "회원가입에 실패했습니다. 다시 시도해주세요.")
                }
            }
        }
    }

    private func callPostLogin() {
        let loginRequest = JustOneLoginRequestDTO(
            loginId: loginId,
            password: password
        )

        justOneService.postLogin(data: loginRequest) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                print("✅ 자동 로그인 성공!")
                print("memberId: \(data.memberId)")
                print("accessToken: \(data.accessToken)")

                // 토큰 저장
                TokenManager.shared.saveAccessToken(data.accessToken)

                // 완료 화면으로 이동
                let nextVC = CompleteViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)

            case .failure(let error):
                print("❌ 자동 로그인 실패: \(error.localizedDescription)")
                // 로그인 실패 시에도 완료 화면으로 이동 (사용자가 직접 로그인하도록)
                let nextVC = CompleteViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    //MARK: - Event
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
