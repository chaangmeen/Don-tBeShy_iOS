//
//  StrinExtension.swift
//  Don_tBeShy
//
//  Created by 전창민 on 27/06/2019.
//  Copyright © 2019 min. All rights reserved.
//

import Foundation
import UIKit
extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
    }
    // String + 1
    func indexOffset(by distance: Int) -> String.Index? {
        return index(startIndex, offsetBy: distance, limitedBy: endIndex)
    }
    
    func SizeOf_String( font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size
    }
}

public extension String {
    
    // String[1]
    public subscript(index: Int) -> Character? {
        guard !self.isEmpty, let stringIndex = self.index(startIndex, offsetBy: index, limitedBy: self.index(before: endIndex)) else { return nil }
        return self[stringIndex]
    }
    
    // String[0..<1]
    public subscript(range: Range<Int>) -> Substring? {
        guard let left = indexOffset(by: range.lowerBound) else { return nil }
        guard let right = index(left, offsetBy: range.upperBound - range.lowerBound,
                                limitedBy: endIndex) else { return nil }
        return self[left..<right]
    }
    
    // String[0...1]
    public subscript(range: ClosedRange<Int>) -> Substring? {
        if range.upperBound < 0 {
            guard abs(range.lowerBound) <= count else { return nil }
            return self[(count - abs(range.lowerBound))...]
        }
        guard let left = indexOffset(by: range.lowerBound) else { return nil }
        guard let right = index(left, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return self[left...right]
    }
    
    // String[..<1]
    public subscript(value: PartialRangeUpTo<Int>) -> Substring? {
        if value.upperBound < 0 {
            guard abs(value.upperBound) <= count else { return nil }
            return self[..<(count - abs(value.upperBound))]
        }
        guard let right = indexOffset(by: value.upperBound) else { return nil }
        return self[..<right]
    }
    
    // String[...1]
    public subscript(value: PartialRangeThrough<Int>) -> Substring? {
        guard let right = self.indexOffset(by: value.upperBound) else { return nil }
        return self[...right]
    }
    
    // String[1...]
    public subscript(value: PartialRangeFrom<Int>) -> Substring? {
        guard let left = self.indexOffset(by: value.lowerBound) else { return nil }
        return self[left...]
    }
    
    // String["substring"]
    public subscript(string: String) -> [Range<String.Index>] {
        var occurences = [Range<String.Index>]()
        var initialLeftBound = startIndex
        while initialLeftBound < endIndex {
            guard let range = self.range(of: string, options: [], range: initialLeftBound..<endIndex, locale: nil) else { break }
            occurences.append(range)
            initialLeftBound = range.upperBound
        }
        return occurences
    }
    
    // String["begin"..."end"]
    public subscript(range: ClosedRange<String>) -> [ClosedRange<String.Index>] {
        var occurences = [ClosedRange<String.Index>]()
        var initialLeftBound = startIndex
        while initialLeftBound < endIndex {
            guard let beginRange = self.range(of: range.lowerBound, options: [], range: initialLeftBound..<endIndex, locale: nil) else { break }
            guard let endRange = self.range(of: range.upperBound, options: [], range: beginRange.upperBound..<endIndex, locale: nil) else { break }
            occurences.append(beginRange.lowerBound...endRange.upperBound)
            initialLeftBound = endRange.upperBound
        }
        return occurences
    }
    
    // String["begin"..<"end"]
    public subscript(range: Range<String>) -> [Range<String.Index>] {
        var occurences = [Range<String.Index>]()
        var initialLeftBound = startIndex
        while initialLeftBound < endIndex {
            guard let beginRange = self.range(of: range.lowerBound, options: [], range: initialLeftBound..<endIndex, locale: nil) else { break }
            guard let endRange = self.range(of: range.upperBound, options: [], range: beginRange.upperBound..<endIndex, locale: nil) else { break }
            occurences.append(beginRange.upperBound..<endRange.lowerBound)
            initialLeftBound = endRange.upperBound
        }
        return occurences
    }
    
    // String[Character("a")]
    public subscript(character: Character) -> [String.Index] {
        var occurences = [String.Index]()
        var initialLeftBound = startIndex
        while initialLeftBound < endIndex {
            guard let beginRange = self.range(of: String(character), options: [], range: initialLeftBound..<endIndex, locale: nil) else { break }
            occurences.append(beginRange.lowerBound)
            initialLeftBound = beginRange.upperBound
        }
        return occurences
    }
    
    // String["begin"...]
    public subscript(range: PartialRangeFrom<String>) -> PartialRangeFrom<String.Index>? {
        guard self.indexOffset(by: range.lowerBound.count) != nil else { return nil }
        guard let beginRange = self.range(of: range.lowerBound, options: [], range: startIndex..<endIndex, locale: nil) else { return nil }
        return beginRange.upperBound...
    }
    
    // String[..."end"]
    public subscript(range: PartialRangeThrough<String>) -> PartialRangeThrough<String.Index>? {
        guard self.indexOffset(by: range.upperBound.count) != nil else { return nil }
        guard let endRange = self.range(of: range.upperBound, options: [], range: startIndex..<endIndex, locale: nil) else { return nil }
        return ...endRange.lowerBound
    }
}

public extension Substring {
    
    var string: String {
        return String(self)
    }
}

public extension Optional where Wrapped == Substring {
    
    var string: String? {
        guard let substring = self else { return nil }
        return String(substring)
    }
}
