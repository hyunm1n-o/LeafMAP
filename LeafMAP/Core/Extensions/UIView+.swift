//
//  UIView+.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
