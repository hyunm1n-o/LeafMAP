//
//  MyLogTableViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit
import SnapKit
import Then

class MyLogTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "MyLogTableViewCell"
    
    //MARK: - Components
    private lazy var icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pMedium, size: 16)!,
        textColor: .gray900
    )
    
    private lazy var badgeView = UIView().then {
        $0.backgroundColor = .green01
        $0.layer.cornerRadius = 10
        $0.isHidden = true
    }
    
    private lazy var badgeCount = AppLabel(
        text: "",
        font: UIFont(name: AppFontName.pSemiBold, size: 11)!,
        textColor: .white
    )
    
    private lazy var arrow = UIImageView().then {
        $0.image = UIImage(named: "grayArrow")
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
        badgeView.addSubview(badgeCount)
        contentView.addSubviews([icon, titleLabel, badgeView, arrow])
        
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        badgeView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
            $0.width.greaterThanOrEqualTo(20)
        }
        
        badgeCount.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(6)
        }
        
        arrow.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    
    public func configure(iconName: String, title: String, count: Int = 0) {
        icon.image = UIImage(named: iconName)
        titleLabel.text = title
        
        if count > 0 {
            badgeView.isHidden = false
            badgeCount.text = "\(count)"
        } else {
            badgeView.isHidden = true
        }
    }
}
