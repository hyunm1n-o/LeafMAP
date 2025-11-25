//
//  EditInfoViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class EditInfoViewController: UIViewController {
    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    let memberService = MemberService()

    private var currentMemberInfo: MemberGetResponseDTO?
    
    // MARK: - View
    private lazy var editInfoView = EditInfoView()
    
    // MARK: - Data
    private let majors = [
        "공공인재학부",
        "미래융합학부1",
        "미래융합학부2",
        "자유전공학부",
        "경영학부",
        "글로벌비즈니스어학부",
        "아동청소년학과",
        "토목건축공학과",
        "도시공학과",
        "물류시스템공학과",
        "나노화학생명공학과",
        "전자컴퓨터공학과",
        "소프트웨어학과",
        "금융정보공학과"
    ]
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(editInfoView)
        editInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavigationBar()
        setupDropDowns()
        setupActions()
        setupTextFieldObservers()
        
        callGetMember()
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
            title: "정보 수정하기",
            textColor: .gray900
        )

        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    // MARK: - DropDown
    private func setupDropDowns() {
        editInfoView.majorDropDown.setOptions(majors)
        editInfoView.hopeMajorDropDown.setOptions(majors)
        
        editInfoView.majorDropDown.onSelect = { [weak self] _, _ in
            self?.updateNextButtonState()
        }
        
        editInfoView.hopeMajorDropDown.onSelect = { [weak self] _, _ in
            self?.updateNextButtonState()
        }
    }
    
    // MARK: - Actions
    private func setupActions() {
        editInfoView.nextButton.addTarget(
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
            object: editInfoView.idTextField
        )
    }
    
    @objc private func textFieldDidChange(_ notification: Notification) {
        updateNextButtonState()
    }
    
    // MARK: - 버튼 활성화 상태 갱신
    private func updateNextButtonState() {
        let nickname = editInfoView.idTextField.getText()
        let currentMajor = editInfoView.majorDropDown.getSelectedText()
        let hopeMajor = editInfoView.hopeMajorDropDown.getSelectedText()
        
        let isFormValid = !nickname.isEmpty && currentMajor != nil && hopeMajor != nil
        
        editInfoView.nextButton.setButtonState(
            isEnabled: isFormValid,
            enabledColor: .green01,
            disabledColor: .disable,
            enabledTitleColor: .white,
            disabledTitleColor: .white
        )
    }
    
    // MARK: - 버튼 클릭 시 검증
    @objc private func nextButtonTapped() {
        let nickname = editInfoView.idTextField.getText()
        let currentMajor = editInfoView.majorDropDown.getSelectedText()
        let hopeMajor = editInfoView.hopeMajorDropDown.getSelectedText()
        
        var hasError = false
        
        if nickname.isEmpty {
            hasError = true
            editInfoView.idTextField.showError(message: "닉네임을 입력해주세요")
        }
        
        if currentMajor == nil {
            hasError = true
            editInfoView.majorDropDown.showError(message: "현재 학과를 선택해주세요")
        }
        
        if hopeMajor == nil {
            hasError = true
            editInfoView.hopeMajorDropDown.showError(message: "희망 학과를 선택해주세요")
        }
        
        updateNextButtonState()

        if hasError { return }

        // 회원정보 수정 API 호출
        callPatchMember(
            nickname: nickname,
            currentMajor: currentMajor!,
            hopeMajor: hopeMajor!
        )
    }
    
    // MARK: - Network
    // 회원 정보 조회
    private func callGetMember() {
        memberService.getMember { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                print("✅ 회원 정보 조회 성공")
                self.currentMemberInfo = data
                
                // 기존 정보 표시
                self.editInfoView.idTextField.setText(data.nickname)
                self.editInfoView.majorDropDown.setSelectedOption(data.major)
                self.editInfoView.hopeMajorDropDown.setSelectedOption(data.desiredMajor)
                
                self.updateNextButtonState()
                
            case .failure(let error):
                print("❌ 회원 정보 조회 실패: \(error.localizedDescription)")
                self.showAlert(message: "회원 정보를 불러올 수 없습니다.")
            }
        }
    }
    
    // 회원정보 수정
    private func callPatchMember(nickname: String, currentMajor: String, hopeMajor: String) {
        let patchRequest = MemberPatchRequestDTO(
            nickname: nickname,
            major: currentMajor,
            desiredMajor: hopeMajor
        )
        
        memberService.patchMember(data: patchRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                print("✅ 회원정보 수정 성공!")
                print("  - nickname: \(data.nickname)")
                print("  - major: \(data.major)")
                print("  - desiredMajor: \(data.desiredMajor)")
                
                // 성공 후 이전 화면
                let alert = UIAlertController(
                    title: "수정 완료",
                    message: "회원정보가 수정되었습니다.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true)
                
            case .failure(let error):
                print("❌ 회원정보 수정 실패: \(error.localizedDescription)")
                
                if case .serverError(_, let message) = error {
                    self.showAlert(message: message)
                } else {
                    self.showAlert(message: "회원정보 수정에 실패했습니다. 다시 시도해주세요.")
                }
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
