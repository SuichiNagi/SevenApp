//
//  String+Ext.swift
//  Seven App UIKit
//
//  Created by Aldrei Glenn Nuqui on 7/11/24.
//

import Foundation
import RegexBuilder

extension String {
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-ZA-z]{2,65}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
