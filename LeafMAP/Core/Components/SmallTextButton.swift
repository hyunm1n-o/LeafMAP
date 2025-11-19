//
//  SmallTextButton.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class SmallTextButton: UIButton {
    init(
        title: String,
        titleColor: UIColor = .gray,
        font: UIFont = UIFont(name: AppFontName.pRegular, size: 12)!
    ){
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
