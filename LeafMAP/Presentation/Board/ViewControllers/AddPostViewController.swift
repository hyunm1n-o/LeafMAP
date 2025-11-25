//
//  AddPostViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit
import PhotosUI

// 작성/수정 모드 enum 추가
enum PostMode {
    case create
    case edit(postId: Int, existingData: PostDetailResponseDTO)
}

class AddPostViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let boardCategory: String
    private var keyboardHeight: CGFloat = 0
    let postService = PostService()
    
    private let mode: PostMode
    private var selectedImage: UIImage?
    
    // MARK: - View
    private lazy var addPostView = AddPostView().then {
        $0.titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        $0.addressTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        $0.postImageButton.addTarget(self, action: #selector(postImageButtonTapped), for: .touchUpInside)
        $0.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Init
    init(boardCategory: String, mode: PostMode = .create) {
        self.boardCategory = boardCategory
        self.mode = mode
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
        tapGesture.cancelsTouchesInView = false
        addPostView.scrollView.addGestureRecognizer(tapGesture)
        
        setupNavigationBar()
        setupKeyboard()
        setupTextViewDelegate()
        updateAddButtonState()
        
        // 맛집 게시판만 주소 입력 가능
        addPostView.setAddressFieldHidden(boardCategory != "RESTAURANT")
        
        // 수정 모드면 기존 데이터 로드
        configureForMode()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 모드에 따른 초기 설정
    private func configureForMode() {
        switch mode {
        case .create:
            addPostView.setButtonTitle("게시글 등록하기")
            
        case .edit(_, let data):
            addPostView.setButtonTitle("게시글 수정하기")
            
            // 기존 데이터 채우기
            addPostView.titleTextField.text = data.title
            addPostView.contentTextView.text = data.content
            addPostView.contentTextView.textColor = .gray900
            
            if let address = data.address, !address.isEmpty {
                addPostView.addressTextField.text = address
            }
            
            // 기존 이미지 로드
            if let imageUrl = data.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                addPostView.postImageView.kf.setImage(with: url)
                addPostView.postImageButton.setImage(nil, for: .normal)
                addPostView.imageLabel.isHidden = true
            }
            
            updateAddButtonState()
        }
    }
    
    // MARK: - Network
    func callCreatePost() {
        guard let title = addPostView.titleTextField.text,
              let content = addPostView.contentTextView.text else { return }
        
        // address 처리 수정
        let address: String?
        if boardCategory == "RESTAURANT" {
            let addressText = addPostView.addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            address = (addressText?.isEmpty == false) ? addressText : nil
        } else {
            address = nil
        }
        
        let requestData = PostCreateRequestDTO(
            title: title,
            content: content,
            address: address
        )
        
        // 디버깅
        print("📤 전송 데이터:")
        print("  - title: \(title)")
        print("  - content: \(content)")
        print("  - address: \(address ?? "nil")")
        print("  - boardType: \(boardCategory)")
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        if let imageData = imageData {
            print("  - image size: \(imageData.count) bytes")
        } else {
            print("  - image: nil")
        }
        
        postService.createPost(
            boardType: boardCategory,
            data: requestData,
            image: imageData,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    print("✅ 게시글 작성 성공: postId = \(response.postId)")
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    print("❌ 게시글 작성 실패: \(error.localizedDescription)")
                }
            })
    }

    func callUpdatePost(postId: Int) {
        guard let title = addPostView.titleTextField.text,
              let content = addPostView.contentTextView.text else { return }
        
        // address 처리 수정
        let address: String?
        if boardCategory == "RESTAURANT" {
            let addressText = addPostView.addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            address = (addressText?.isEmpty == false) ? addressText : nil
        } else {
            address = nil
        }
        
        let requestData = PostUpdateRequestDTO(
            title: title,
            content: content,
            address: address
        )
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        postService.updatePost(
            boardType: boardCategory,
            postId: postId,
            data: requestData,
            image: imageData,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ 게시글 수정 성공")
                    self.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    print("❌ 게시글 수정 실패: \(error.localizedDescription)")
                }
            })
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
        
        // 모드에 따라 타이틀 변경
        let navTitle: String
        switch mode {
        case .create:
            navTitle = displayTitle + " - 게시글 작성"
        case .edit:
            navTitle = displayTitle + " - 게시글 수정"
        }
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: navTitle,
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
    
    @objc private func textFieldChanged() {
        updateAddButtonState()
    }
    
    @objc private func addButtonTapped() {
        switch mode {
        case .create:
            callCreatePost()
        case .edit(let postId, _):
            callUpdatePost(postId: postId)
        }
    }
    
    @objc private func dismissKeyboard() {
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
// PHPickerViewControllerDelegate
extension AddPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.selectedImage = image
                    self?.addPostView.postImageView.image = image
                    self?.addPostView.postImageButton.setImage(nil, for: .normal)
                    self?.addPostView.imageLabel.isHidden = true
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            addPostView.postImageView.image = image
            addPostView.postImageButton.setImage(nil, for: .normal)
            addPostView.imageLabel.isHidden = true
        }
    }
}
