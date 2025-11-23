//
//  CommentTableViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    
    private lazy var userIcon = UIImageView().then {
        $0.image = UIImage(named: "user")
    }
    
    private lazy var nicknameLabel = AppLabel(text: "",
                                              font: UIFont(name: AppFontName.pRegular, size: 15)!,
                                              textColor: .gray900)
    
    private lazy var contentLabel = AppLabel(text: "",
                                             font: UIFont(name: AppFontName.pRegular, size: 14)!,
                                             textColor: .gray)
    
    public lazy var detailButton = TouchAreaButton().then {
        $0.setImage(UIImage(named: "dotdotdot"), for: .normal)
    }
    
    //MARK: - init
    private var leadingConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.addSubviews([userIcon, nicknameLabel, contentLabel, detailButton])
        
        userIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            self.leadingConstraint = $0.leading.equalToSuperview().offset(24).constraint
            $0.size.equalTo(20)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(userIcon.snp.trailing).offset(6)
            $0.centerY.equalTo(userIcon)
        }
        
        detailButton.snp.makeConstraints {
            $0.centerY.equalTo(userIcon)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(userIcon)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(nickname: String, content: String, depth: Int, isAuthor: Bool) {
        nicknameLabel.text = nickname
        contentLabel.text = content
        // depth에 따른 들여쓰기 처리 등
    }
}
