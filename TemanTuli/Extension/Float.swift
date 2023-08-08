//
//  Float.swift
//  TemanTuli
//
//  Created by Irfan Dary Sujatmiko on 07/08/23.
//

import Foundation
extension Double {
    ///Function for rounding long numbers
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
