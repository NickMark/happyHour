//
//  Label.swift
//  WaffleHouseNick
//
//  Created by Nicholas Evans on 2016-10-03.
//  Copyright © 2016 Nicholas Evans. All rights reserved.
//


import UIKit

class MultilineLabelThatWorks : UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        preferredMaxLayoutWidth = bounds.width
        super.layoutSubviews()
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = layoutMargins.apply(rect: bounds)
        rect = super.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        return layoutMargins.inverse.apply(rect: rect)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: layoutMargins.apply(rect: rect))
    }
}

extension UIEdgeInsets {
    var inverse : UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    func apply(rect: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(rect, self)
    }
}

