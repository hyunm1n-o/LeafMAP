//
//  UIFont+.swift
//  LeafMAP
//
//  Created by 오현민 on 11/20/25.
//

import UIKit

struct AppFontName {
    static let pRegular = "Pretendard-Regular"
    static let pMedium = "Pretendard-Medium"
    static let pBold = "Pretendard-Bold"
    static let pSemiBold = "Pretendard-SemiBold"
}

extension UIFont {
    public class func title1Bold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 28, lineHeight: 1.2)
    }
    
    // Create Font with letter spacing and line height
    private class func createFont(name: String, size: CGFloat, lineHeight: CGFloat) -> UIFont {
        // Create the UIFont object
        let font = UIFont(name: name, size: size)!
        
        // Create the paragraph style for line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        
        // Create attributed string with font, letterSpacing, and line height
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: -size * 0.04,
            .paragraphStyle: paragraphStyle
        ]
        
        // Return an attributed font
        let attributedFont = NSAttributedString(string: "a", attributes: attributes)
        let fontWithAttributes = attributedFont.attributes(at: 0, effectiveRange: nil)[.font] as! UIFont
        return fontWithAttributes
    }
    
}
