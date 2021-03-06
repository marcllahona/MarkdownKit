//
//  MarkdownCodeEscaping.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//

import UIKit

public class MarkdownCodeEscaping: MarkdownElement {

  private static let regex = "(?<!\\\\)(?:\\\\\\\\)*+(`+)(.*?[^`].*?)(\\1)(?!`)"

  public var regex: String {
    return MarkdownCodeEscaping.regex
  }

  public func regularExpression() throws -> NSRegularExpression {
    return try NSRegularExpression(pattern: regex, options: .DotMatchesLineSeparators)
  }

  public func match(match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
    let range = match.rangeAtIndex(2)
    // escaping all characters
    let matchString = attributedString.attributedSubstringFromRange(range).string
    let escapedString = Array<UInt16>(matchString.utf16)
      .map { (value: UInt16) -> String in String(format: "%04x", value) }
      .reduce("") { (string: String, character: String) -> String in
        return "\(string)\(character)"
    }
    attributedString.replaceCharactersInRange(range, withString: escapedString)
  }

}
