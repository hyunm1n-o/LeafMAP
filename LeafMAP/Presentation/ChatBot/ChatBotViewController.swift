//
//  ChatBotViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class ChatBotViewController: UIViewController {
    // MARK: - Properties
    let navigationBarManager = NavigationManager()
    let justOneService = JustOneService()
    
    var messages: [ChatCollectionViewCell.Model] = []
    var isLoading = false
    
    // MARK: - View
    private let chatView = ChatBotView()
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(chatView)
        chatView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupCollectionView()
        setupNavigationBar()
        addKeyboardObservers()
        addTapGestureToDismissKeyboard()
        
        let welcomeMessage = ChatCollectionViewCell.Model(
            message: "안녕하세요! 궁금한 것을 물어보세요",
            chatType: .receive,
            posts: nil
        )
        messages.append(welcomeMessage)
        chatView.collectionView.reloadData()
        
        chatView.sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupCollectionView() {
        chatView.collectionView.delegate = self
        chatView.collectionView.dataSource = self
    }
    
    // MARK: - Network
    // 챗봇 API
    func callChatAPI(message: String) {
        guard !isLoading else { return }
        
        isLoading = true
        
        let requestData = JustOneChatRequestDTO(message: message)
        
        justOneService.chat(
            data: requestData,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let data):
                    print("✅ 챗봇 응답 성공")
                    print(" message: \(data.message)")
                    print(" posts: \(data.posts.count)개")
                    
                    //  AI 응답 추가
                    let aiMessage = ChatCollectionViewCell.Model(
                        message: data.message,
                        chatType: .receive,
                        posts: data.posts.isEmpty ? nil : data.posts
                    )
                    self.messages.append(aiMessage)
                    
                    DispatchQueue.main.async {
                        self.chatView.collectionView.reloadData()
                        self.scrollToBottom()
                    }
                    
                case .failure(let error):
                    print("❌ 챗봇 응답 실패: \(error.localizedDescription)")
                    
                    let errorMessage = ChatCollectionViewCell.Model(
                        message: "죄송합니다. 오류가 발생했습니다. 다시 시도해주세요.",
                        chatType: .receive,
                        posts: nil
                    )
                    self.messages.append(errorMessage)
                    
                    DispatchQueue.main.async {
                        self.chatView.collectionView.reloadData()
                        self.scrollToBottom()
                    }
                }
            })
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
            title: "🍃 풀잎 AI",
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapSendButton() {
        guard let text = chatView.commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return }
        
        // 사용자 메시지 추가
        let userMessage = ChatCollectionViewCell.Model(
            message: text,
            chatType: .send,
            posts: nil
        )
        messages.append(userMessage)
        
        chatView.collectionView.reloadData()
        scrollToBottom()
        
        // API 호출
        callChatAPI(message: text)
        
        // 텍스트필드 초기화
        chatView.commentTextField.text = ""
    }
    
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        
        let lastIndexPath = IndexPath(item: messages.count - 1, section: 0)
        chatView.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Keyboard Setting
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard
            let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let keyboardHeight = frame.height - view.safeAreaInsets.bottom
        
        chatView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-keyboardHeight)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.scrollToBottom()
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        chatView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionView Delegate / DataSource
extension ChatBotViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChatCollectionViewCell.identifier,
            for: indexPath
        ) as! ChatCollectionViewCell
        
        cell.model = messages[indexPath.row]
        
        // 게시글 탭 콜백 설정
        cell.onPostTapped = { [weak self] post in
            self?.navigateToPost(post: post)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]
        
        let maxWidth = UIScreen.main.bounds.width * 2/3 - 32
        let font = UIFont(name: AppFontName.pRegular, size: 16)!
        
        let textSize = (message.message as NSString).boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        
        let textHeight = textSize.height + 32 + 16  // 패딩 + 상하 여백
        
        // 게시글 이미지 높이 계산
        var postsHeight: CGFloat = 0
        if let posts = message.posts, !posts.isEmpty {
            postsHeight = CGFloat(posts.count) * 76 + CGFloat(posts.count - 1) * 8 + 16
        }
        
        let totalHeight = textHeight + postsHeight
        
        return CGSize(width: view.bounds.width, height: max(totalHeight, 60))
    }
    
    // 게시글로 이동
    private func navigateToPost(post: JustOneChatPostPreviewDTO) {
        print("🔗 게시글 이동: postId=\(post.postId), boardType=\(post.boardType)")
        
        let boardType = post.boardType
        let postId = post.postId
        
        // 학과 팁 게시판이면 MajorTipViewController로 이동
        if boardType == "MAJOR_TIPS" {
            let nextVC = MajorTipViewController(postId: postId)
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            // 일반 게시판은 PostDetailViewController로 이동
            let nextVC = PostDetailViewController(boardCategory: boardType, postId: postId)
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
