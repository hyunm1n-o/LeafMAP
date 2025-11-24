//
//  AddPostView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//
import UIKit

class AddPostView: UIView {

    // MARK: - Components
    public lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.keyboardDismissMode = .interactive
    }
    
    public lazy var contentView = UIView()
    
    public lazy var titleTextField = UITextField().then {
        $0.placeholder = "게시글 제목을 입력하세요"
        $0.font = UIFont(name: AppFontName.pMedium, size: 20)
        $0.textColor = .gray900
        $0.borderStyle = .none
    }
    
    private lazy var seperateLine = UIView().then {
        $0.backgroundColor = .disable
        $0.snp.makeConstraints { $0.height.equalTo(1) }
    }
    
    public lazy var imageLabel = AppLabel(text: "눌러서 이미지 추가", font:  UIFont(name: AppFontName.pRegular, size: 18)!, textColor: .gray).then {
            $0.isUserInteractionEnabled = false
        }
    
    public lazy var postImageButton = UIButton().then {
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    public lazy var postImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    public lazy var contentTextView = UITextView().then {
        $0.text = "내용을 입력하세요"
        $0.textColor = .gray
        $0.font = UIFont(name: AppFontName.pRegular, size: 16)
    }
    
    public lazy var addressTextField = UITextField().then {
        $0.placeholder = "주소를 입력하세요"
        $0.font = UIFont(name: AppFontName.pRegular, size: 16)
        $0.textColor = .gray
        $0.borderStyle = .none
    }
    
    public lazy var addButton = AppButton(title: "게시글 등록하기", isEnabled: false)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            titleTextField,
            seperateLine,
            postImageButton,
            postImageView,
            contentTextView,
            addressTextField,
            addButton,
            imageLabel
        ])
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        titleTextField.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        seperateLine.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        imageLabel.snp.makeConstraints {
            $0.center.equalTo(postImageView)
        }
        
        postImageButton.snp.makeConstraints {
            $0.top.equalTo(seperateLine.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        postImageView.snp.makeConstraints {
            $0.edges.equalTo(postImageButton)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        
        addressTextField.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(24)
            $0.bottom.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Helpers
    func setAddressFieldHidden(_ hidden: Bool) {
        addressTextField.isHidden = hidden
    }
    
    func setButtonTitle(_ title: String) {
        addButton.setTitle(title, for: .normal)
    }
}
