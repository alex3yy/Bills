//
//  Double+Rounded.swift
//  Bills
//
//  Created by Alex Zaharia on 29.06.2023.
//

import Foundation

extension Double {
    func rounded(fractionDigits: Int) -> Double {
        let divisor = pow(10, Double(fractionDigits))
        return (self * divisor).rounded() / divisor
    }
}
