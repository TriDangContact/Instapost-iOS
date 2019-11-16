//
//  InstapostRegex.swift
//  InstaPost2
//
//  Created by Tri Dang on 11/15/19.
//  Copyright © 2019 Tri Dang. All rights reserved.
//

import Foundation

// simple regex helper to make it easier to use regex
// Source: https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
