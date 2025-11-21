//
//  AppButton.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

class AppButton: UIButton {
    
    init(
        title: String = "",
        titleColor: UIColor = .white,
        isEnabled: Bool = true,
        icon: String? = nil
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = isEnabled ? UIColor.green01 : UIColor.disable
        
        // 안전하게 아이콘 처리
        if let iconName = icon, !iconName.isEmpty {
            self.setImage(UIImage(named: iconName), for: .normal)
            self.setImage(UIImage(named: iconName), for: .highlighted)
        }
        
        self.titleLabel?.font = UIFont(name: AppFontName.pSemiBold, size: 18)
        self.layer.cornerRadius = 12
        
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setButtonState(isEnabled: Bool, enabledColor: UIColor, disabledColor: UIColor, enabledTitleColor: UIColor, disabledTitleColor: UIColor) {
        // isEnabled 값에 따라 배경색을 다르게 설정
        self.backgroundColor = isEnabled ? enabledColor : disabledColor
        self.setTitleColor(isEnabled ? enabledTitleColor : disabledTitleColor, for: .normal)
        self.isEnabled = isEnabled
    }

}
