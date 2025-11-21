//
//  HomeTableViewCell.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    //MARK: - Properties
    static let identifier = "HomeTableViewCell"
    
    //MARK: - Components
    private lazy var sub = AppLabel(text: "",
                                    font: UIFont(name: AppFontName.pRegular, size: 12)!,
                                    textColor: .gray900).then {
        $0.textAlignment = .left
    }
    
    private lazy var arrowIcon = UIImageView().then {
        $0.image = UIImage(named: "Icon")
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
        addSubviews([sub, arrowIcon])
        sub.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
        }
        
        arrowIcon.snp.makeConstraints {
            $0.leading.equalTo(sub.snp.trailing).offset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    public func configure(title: String) {
        sub.text = title
    }

}
