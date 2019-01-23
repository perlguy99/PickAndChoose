//
//  PaddedLabel.swift
//  PickAndChoose
//
//  Created by Brent Michalski on 1/23/19.
//  Copyright © 2019 Perlguy, Inc. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    var topInset: CGFloat    = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat   = 0.0
    var rightInset: CGFloat  = 0.0

    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + topInset, height: size.height + topInset + bottomInset)
    }
}
