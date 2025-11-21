//
//  UIStackView+.swift
//  LeafMAP
//
//  Created by 오현민 on 11/21/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
