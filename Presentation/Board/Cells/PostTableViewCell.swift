//
//  PostTableViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "HomeTableViewCell"
    
    //MARK: - Components
    private lazy var titleLabel = AppLabel(text: "제목",
                                    font: UIFont(name: AppFontName.pSemiBold, size: 16)!,
                                    textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var certificationBadge = UIImageView().then {
        $0.image = UIImage(named: "badge")
    }
    
    private lazy var contentLabel = AppLabel(text: "내용",
                                        font: UIFont(name: AppFontName.pRegular, size: 14)!,
                                        textColor: .gray).then {
        $0.textAlignment = .left
    }
    
    private lazy var postInfoLabel = AppLabel(text: "사용자 | 시간",
                                    font: UIFont(name: AppFontName.pSemiBold, size: 12)!,
                                         textColor: .disable).then {
        $0.textAlignment = .right
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubviews([titleLabel, certificationBadge, contentLabel, postInfoLabel])
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().inset(22)
        }
        
        certificationBadge.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        postInfoLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(24)
        }
        
    }
    
    public func configure(title: String, content: String, postInfo: String, isCertified: Bool) {
        titleLabel.text = title
        contentLabel.text = content
        postInfoLabel.text = postInfo
        certificationBadge.isHidden = !isCertified
    }
}
