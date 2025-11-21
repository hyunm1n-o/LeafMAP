import UIKit
class SelectMajorViewController: UIViewController {
    
    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    
    // MARK: - View
    private lazy var selectMajorView = SelectMajorView()
    
    // MARK: - Data
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
        
        // 다음 화면 이동
        let nextVC = CompleteViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - Event
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
