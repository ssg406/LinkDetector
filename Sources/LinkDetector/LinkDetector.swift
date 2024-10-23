// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

struct LinkDetector {
    
    /// Adds color and underline styling and
    /// - Parameters:
    ///   - text: Input text
    ///   - phoneColor: Phone link highlight color
    ///   - linkColor: Web link highlight color
    ///   - addressColor: Address highlight color
    /// - Returns: Styled attributed string with linked phone numbers and URLs
    public static func detectLinks(in text: String, phoneColor: UIColor = .blue, linkColor: UIColor = .blue, addressColor: UIColor = .blue) -> AttributedString {
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let phoneAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: phoneColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let addressAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue, // update address color
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributedText = NSMutableAttributedString(string: text)
        
        let dataDetector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        
        let results = dataDetector.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))
        
        for result in results {
            if result.resultType == .link {
                attributedText.addAttributes(linkAttributes, range: result.range)
                attributedText.addAttribute(.link, value: result.url ?? "", range: result.range)
            } else if result.resultType == .phoneNumber {
                attributedText.addAttributes(phoneAttributes, range: result.range)
                attributedText.addAttribute(.link, value: result.phoneNumber ?? "", range: result.range)
            } else if result.resultType == .address {
                if let addressComponents = result.addressComponents {
                    let street = addressComponents[NSTextCheckingKey.street]
                    let city = addressComponents[NSTextCheckingKey.city]
                    let state = addressComponents[NSTextCheckingKey.state]
                    let zip = addressComponents[NSTextCheckingKey.zip]
                    let formattedAddress = "\(street ?? "") \(city ?? ""), \(state ?? ""), \(zip ?? "")"
                    if street != nil {
                        // Add address attributes and links only if at least street exists
                        attributedText.addAttributes(addressAttributes, range: result.range)
                        attributedText.addAttribute(.link, value: formattedAddress, range: result.range)
                    }
                }
            }
        }
        return AttributedString(attributedText)
    }
}
