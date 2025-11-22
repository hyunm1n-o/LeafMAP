//
//  TouchAreaButton.swift
//  LeafMAP
//
//  Created by 오현민 on 11/22/25.
//

import Foundation
import UIKit

class TouchAreaButton: UIButton {
    let minSize: CGFloat = 44
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let width = max(minSize, bounds.width)
        let height = max(minSize, bounds.height)
        let area = CGRect(x: bounds.midX - width/2,
                           y: bounds.midY - height/2,
                           width: width,
                           height: height)
        return area.contains(point)
    }
}
