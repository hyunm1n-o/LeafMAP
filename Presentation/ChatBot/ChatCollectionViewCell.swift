//
//  ChatCollectionViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ChatCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "ChatCollectionViewCell"
    
    enum ChatType: CaseIterable {
        case receive  // 봇
        case send     // 사용자
    }
    
    struct Model {
        let message: String
        let chatType: ChatType
        let posts: [JustOneChatPostPreviewDTO]?
    }
    
    var model: Model? {
        didSet { bind() }
    }
    
    var onPostTapped: ((JustOneChatPostPreviewDTO) -> Void)?
    
    // MARK: - Components
    private lazy var messageTextView = UITextView().then {
        $0.font = UIFont(name: AppFontName.pRegular, size: 16)!
        $0.textColor = .gray900
        $0.textAlignment = .left
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.textContainer.lineFragmentPadding = 0
        $0.allowsEditingTextAttributes = false
    }
    
    private lazy var postsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fill
        $0.isHidden = true
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubviews([messageTextView, postsStackView])
    }
    
    // MARK: - Bind
    private func bind() {
        guard let model = model else { return }
        
        messageTextView.text = model.message
        
        // 게시글 이미지 표시
        postsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let posts = model.posts, !posts.isEmpty {
            postsStackView.isHidden = false
            
            for post in posts {
                let postView = createPostView(post: post)
                postsStackView.addArrangedSubview(postView)
            }
        } else {
            postsStackView.isHidden = true
        }
        
        // 레이아웃 설정
        switch model.chatType {
        case .receive:
            // 봇 응답 - 회색, 왼쪽 정렬
            messageTextView.backgroundColor = .gray1
            
            messageTextView.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(8)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.lessThanOrEqualToSuperview().offset(-60)
                $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 2/3)
            }
            
            postsStackView.snp.remakeConstraints {
                $0.top.equalTo(messageTextView.snp.bottom).offset(8)
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.lessThanOrEqualToSuperview().offset(-60)
                $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 2/3)
                $0.bottom.equalToSuperview().inset(8)
            }
            
        case .send:
            // 사용자 질문 - 초록색, 오른쪽 정렬
            messageTextView.backgroundColor = .boxGreen
            
            messageTextView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(8)
                $0.trailing.equalToSuperview().inset(24)
                $0.leading.greaterThanOrEqualToSuperview().offset(60)
                $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width * 2/3)
            }
            
            postsStackView.snp.remakeConstraints {
                $0.height.equalTo(0)
            }
        }
    }
    
    // 게시글 카드 생성 (제스처 추가)
    private func createPostView(post: JustOneChatPostPreviewDTO) -> UIView {
        let containerView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray1.cgColor
            $0.isUserInteractionEnabled = true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPostView(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = post.postId
        
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .gray1
        }
        
        let titleLabel = AppLabel(
            text: post.title,
            font: UIFont(name: AppFontName.pMedium, size: 14)!,
            textColor: .gray900
        ).then {
            $0.numberOfLines = 2
        }
        
        let previewLabel = AppLabel(
            text: post.contentPreview,
            font: UIFont(name: AppFontName.pRegular, size: 12)!,
            textColor: .gray
        ).then {
            $0.numberOfLines = 1
        }
        
        containerView.addSubviews([imageView, titleLabel, previewLabel])
        
        // 이미지 로드 (imageUrl이 비어있지 않을 때만)
        if !post.imageUrl.isEmpty, let url = URL(string: post.imageUrl) {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
        
        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        previewLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.lessThanOrEqualToSuperview().inset(8)
        }
        
        containerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(76)
        }
        
        return containerView
    }
    
    @objc
    private func didTapPostView(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view,
              let posts = model?.posts else { return }
        
        let postId = tappedView.tag
        
        // postId로 해당 게시글 찾기
        if let post = posts.first(where: { $0.postId == postId }) {
            onPostTapped?(post)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        postsStackView.isHidden = true
    }
}
