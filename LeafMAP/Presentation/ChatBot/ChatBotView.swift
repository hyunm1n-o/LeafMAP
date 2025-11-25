//
//  ChatBotView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import SnapKit
import Then

class ChatBotView: UIView {

    // MARK: - UI
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0 
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        $0.collectionViewLayout = layout
        $0.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        $0.backgroundColor = .white
        $0.keyboardDismissMode = .interactive
    }

    private lazy var textFieldContainer = UIView().then {
        $0.backgroundColor = .gray1
        $0.layer.cornerRadius = 8
    }

    public lazy var commentTextField = UITextField().then {
        $0.placeholder = "풀잎 AI에게 궁금한 걸 물어보세요"
        $0.font = UIFont(name: AppFontName.pRegular, size: 14)
        $0.textColor = .gray900
        $0.borderStyle = .none
    }

    public lazy var sendButton = UIButton().then {
        $0.setImage(UIImage(named: "send_icon"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        addSubviews([collectionView, textFieldContainer])
        textFieldContainer.addSubviews([commentTextField, sendButton])
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(textFieldContainer.snp.top).offset(-8)
        }

        textFieldContainer.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
