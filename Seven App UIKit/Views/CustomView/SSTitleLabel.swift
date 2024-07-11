//
//  SSTitleLabel.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import UIKit

class SSTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment  = textAlignment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        textColor = .secondaryLabel
        translatesAutoresizingMaskIntoConstraints = false
    }
}
