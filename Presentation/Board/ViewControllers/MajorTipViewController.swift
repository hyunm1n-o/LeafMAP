//
//  MajorTipViewController.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

class MajorTipViewController: UIViewController {
    // MARK: - Properties
    let postService = PostService()
    let navigationBarManager = NavigationManager()
    let postId: Int
    
    // 게시글 데이터 & 댓글 데이터
    private var postDetail: PostDetailResponseDTO?
    private var comments: [PostCommentDTO] = []
    private var displayComments: [PostCommentDTO] = []
    private var replyMode: (isActive: Bool, parentCommentId: Int, parentAuthor: String) = (false, 0, "")
    
    // MARK: - View
    private lazy var majorTipView = MajorTipView().then {
        $0.editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        $0.sendButton.addTarget(self, action: #selector(didTapSendComment), for: .touchUpInside)
        $0.cancelReplyButton.addTarget(self, action: #selector(didTapCancelReply), for: .touchUpInside)
    }
    
    // MARK: - init
    init(postId: Int) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(majorTipView)
        
        majorTipView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addKeyboardObservers()
        setupNavigationBar()
        setDelegate()
        addTapGestureToDismissKeyboard()
        callGetMajoTipDetail()
        
        // 테이블뷰 높이 observer 추가
        majorTipView.commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        majorTipView.commentTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                majorTipView.commentTableView.snp.updateConstraints {
                    $0.height.equalTo(newSize.height)
                }
            }
        }
    }
    
    // MARK: - Network
    func callGetMajoTipDetail() {
        postService.getPostDetail(
            boardType: "MAJOR_TIPS",
            postId: postId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.postDetail = data
                    self.comments = data.comments
                    
                    // 댓글을 계층 구조로 정렬
                    self.displayComments = self.sortCommentsHierarchically(self.comments)
                    
                    self.updateUI(with: data)
                    self.majorTipView.commentTableView.reloadData()
                    
                    // 테이블뷰 높이 업데이트
                    DispatchQueue.main.async {
                        self.majorTipView.commentTableView.layoutIfNeeded()
                    }
                    
                    print("✅ 학과 팁 상세 로드 성공")
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            })
    }
    
    // 댓글을 계층 구조로 정렬
    private func sortCommentsHierarchically(_ comments: [PostCommentDTO]) -> [PostCommentDTO] {
        var result: [PostCommentDTO] = []
        let parentComments = comments.filter { $0.parentId == nil }
        
        for parent in parentComments {
            result.append(parent)
            let children = comments.filter { $0.parentId == parent.commentId }
            result.append(contentsOf: children)
        }
        
        return result
    }
    
    // 댓글 작성 API
    func callCreateComment(content: String, parentId: Int? = nil) {
        let requestData = PostCommentRequestDTO(
            content: content,
            parentId: parentId
        )
        
        postService.createComment(
            postId: postId,
            data: requestData,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let newComment):
                    print("✅ 댓글 작성 성공: \(newComment.commentId)")
                    self.exitReplyMode()
                    self.callGetMajoTipDetail()
                    
                case .failure(let error):
                    print("❌ 댓글 작성 실패: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "댓글 작성 실패",
                        message: "댓글을 작성할 수 없습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            })
    }
    
    // 댓글 삭제 API
    func callDeleteComment(commentId: Int) {
        postService.deleteComment(
            postId: postId,
            commentId: commentId,
            completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ 댓글 삭제 성공")
                    self.callGetMajoTipDetail()
                    
                case .failure(let error):
                    print("❌ 댓글 삭제 실패: \(error.localizedDescription)")
                    let alert = UIAlertController(
                        title: "삭제 실패",
                        message: "댓글을 삭제할 수 없습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            })
    }
    
    // MARK: - Reply Mode
    private func enterReplyMode(parentCommentId: Int, parentAuthor: String) {
        replyMode = (true, parentCommentId, parentAuthor)
        majorTipView.setReplyMode(isActive: true, parentAuthor: parentAuthor)
        majorTipView.commentTextField.becomeFirstResponder()
    }
    
    private func exitReplyMode() {
        replyMode = (false, 0, "")
        majorTipView.setReplyMode(isActive: false, parentAuthor: "")
        majorTipView.commentTextField.text = ""
    }
    
    // MARK: - Functional
    private func setDelegate() {
        majorTipView.commentTableView.delegate = self
        majorTipView.commentTableView.dataSource = self
    }
    
    //MARK: - Event
    @objc
    private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapEdit() {
        print("희망학과 수정")
        let nextVC = EditInfoViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    private func didTapSendComment() {
        guard let commentText = majorTipView.commentTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !commentText.isEmpty else { return }
        
        if replyMode.isActive {
            callCreateComment(content: commentText, parentId: replyMode.parentCommentId)
        } else {
            callCreateComment(content: commentText, parentId: 0)
        }
        
        view.endEditing(true)
    }
    
    @objc
    private func didTapCancelReply() {
        exitReplyMode()
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
            title: "학과 선택 꿀팁",
            textColor: .gray900
        )
        
        if let navBar = navigationController?.navigationBar {
            navigationBarManager.addBottomLine(to: navBar)
        }
    }
    
    private func updateUI(with data: PostDetailResponseDTO) {
        guard let major = data.major else { return }
        
        majorTipView.configure(
            hopeMajor: major.name,
            keywords: major.keywords,
            description: major.description,
            curriculumUrl: major.curriculumUrl,
            career: major.career
        )
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
        majorTipView.bottomConstraint?.update(offset: -keyboardHeight)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        majorTipView.bottomConstraint?.update(offset: 0)
        
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

// MARK: - Extension
extension MajorTipViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayComments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else { return UITableViewCell() }

        let comment = displayComments[indexPath.row]
        let depth = comment.parentId != nil ? 1 : 0
        
        cell.configure(
            nickname: comment.authorInfo,
            content: comment.content,
            depth: depth,
            isAuthor: comment.isWriter
        )

        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(
            self,
            action: #selector(didTapDetailButton(_:)),
            for: .touchUpInside
        )

        return cell
    }

    @objc
    private func didTapDetailButton(_ sender: UIButton) {
        let row = sender.tag
        let comment = displayComments[row]

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if comment.isWriter {
            sheet.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { [weak self] _ in
                self?.showDeleteCommentAlert(commentId: comment.commentId)
            }))
            sheet.addAction(UIAlertAction(title: "답글 달기", style: .default, handler: { [weak self] _ in
                self?.enterReplyMode(parentCommentId: comment.commentId, parentAuthor: comment.authorInfo)
            }))
        } else {
            sheet.addAction(UIAlertAction(title: "답글 달기", style: .default, handler: { [weak self] _ in
                self?.enterReplyMode(parentCommentId: comment.commentId, parentAuthor: comment.authorInfo)
            }))
        }

        sheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(sheet, animated: true)
    }
    
    private func showDeleteCommentAlert(commentId: Int) {
        let alert = UIAlertController(
            title: "댓글 삭제",
            message: "정말로 이 댓글을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.callDeleteComment(commentId: commentId)
        })
        
        present(alert, animated: true)
    }
}
