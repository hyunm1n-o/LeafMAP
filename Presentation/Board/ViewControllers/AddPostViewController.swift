//
//  AddPostViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit
import PhotosUI

class AddPostViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let boardCategory: String
    private var keyboardHeight: CGFloat = 0
    
    // MARK: - View
    private lazy var addPostView = AddPostView().then {
        // 텍스트필드
        $0.titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        $0.addressTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // 버튼
        $0.postImageButton.addTarget(self, action: #selector(postImageButtonTapped), for: .touchUpInside)
        $0.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Init
    init(boardCategory: String) {
        self.boardCategory = boardCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(addPostView)
        addPostView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 버튼/텍스트뷰 터치 막지 않음
        addPostView.scrollView.addGestureRecognizer(tapGesture)
        
        setupNavigationBar()
        setupKeyboard()
        setupTextViewDelegate()
        updateAddButtonState()
        updateAddButtonState()
        
        // 맛집 게시판만 주소 입력 가능
        addPostView.setAddressFieldHidden(boardCategory != "맛집 게시판")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Network
    func callGetBoardDetail() {
        
    }
    
    // MARK: - Navigation
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        let displayTitle = BoardType(rawValue: boardCategory)?.koreanName ?? boardCategory
        navigationBarManager.setTitle(
            to: navigationItem,
            title: displayTitle + " - 게시글 작성",
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Actions
    private func setupTextViewDelegate() {
        addPostView.contentTextView.delegate = self
    }
    
    // MARK: - 버튼 상태 업데이트
    private func updateAddButtonState() {
        let titleFilled = !(addPostView.titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let contentFilled = addPostView.contentTextView.textColor != .gray && !addPostView.contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        let addressFilled: Bool
        if addPostView.addressTextField.isHidden {
            addressFilled = true
        } else {
            addressFilled = !(addPostView.addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        }
        
        let isFormValid = titleFilled && contentFilled && addressFilled
        
        addPostView.addButton.setButtonState(
            isEnabled: isFormValid,
            enabledColor: .green01,
            disabledColor: .disable,
            enabledTitleColor: .white,
            disabledTitleColor: .white
        )
    }
    
    //MARK: Event
    @objc
    private func textFieldChanged() {
        updateAddButtonState()
    }
    
    @objc
    private func addButtonTapped() {
        print("게시글 등록")
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Image Picker
    @objc private func postImageButtonTapped() {
        let alert = UIAlertController(title: "사진 선택", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "사진 선택", style: .default) { _ in self.openPhotoLibrary() })
        alert.addAction(UIAlertAction(title: "촬영하기", style: .default) { _ in self.openCamera() })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Keyboard
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 버튼/텍스트뷰 터치 막지 않음
        addPostView.scrollView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let info = notification.userInfo,
              let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = frame.height
        addPostView.scrollView.contentInset.bottom = keyboardHeight
        addPostView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        addPostView.scrollView.contentInset.bottom = 0
        addPostView.scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

// MARK: - UITextViewDelegate
extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = ""
            textView.textColor = .gray900
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요"
            textView.textColor = .gray
        }
        updateAddButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateAddButtonState()
    }
}

// MARK: - PHPickerViewControllerDelegate
extension AddPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.addPostView.postImageView.image = image
                    self?.addPostView.postImageButton.setImage(nil, for: .normal)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            addPostView.postImageView.image = image
            addPostView.postImageButton.setImage(nil, for: .normal)
        }
    }
}
