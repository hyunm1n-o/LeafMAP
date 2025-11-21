//
//  SquareView.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SquareView: UIView {
    //MARK: - Properties
    private var titleString: String
    private var subString: String
    
    //MARK: - Components
    private lazy var title = AppLabel(text: titleString,
                                      font: UIFont(name: AppFontName.pSemiBold, size: 16)!,
                                      textColor: .gray900)
    private lazy var sub = AppLabel(text: subString,
                                    font: UIFont(name: AppFontName.pRegular, size: 12)!,
                                    textColor: .gray900).then {
        $0.numberOfLines = 0
    }
    
    //MARK: - init
    init(title: String, sub: String) {
        self.titleString = title
        self.subString = sub
        super.init(frame: .zero)
        
        self.backgroundColor = .gray1
        self.layer.cornerRadius = 12
        self.snp.makeConstraints {
            $0.height.equalTo(88)
        }
        
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetUI
    private func setView() {
        addSubviews([title, sub])
    }
    
    private func setConstraints() {
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(12)
        }
        
        sub.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(4)
            $0.leading.equalTo(title)
        }
    }

}
