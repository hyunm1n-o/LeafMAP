//
//  String+.swift
//  LeafMAP
//
//  Created by 오현민 on 11/25/25.
//

import UIKit

extension String {
    func getEstimatedFrame(with font: UIFont) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width * 2/3, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(
            with: size,
            options: options,
            attributes: [.font: font],
            context: nil
        )
    }
}
