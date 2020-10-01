//
//  String.swift
//  Ketch
//
//  Created by C110 on 15/12/17.
//  Copyright © 2017 C110. All rights reserved.
//

import UIKit

extension String: Error {}

extension String {
    
//    func fromBase64() -> String? {
//        guard let data = Data(base64Encoded: self) else {
//            return ""
//        }
//        
//        return String(data: data, encoding: .utf8)
//    }
//    
//    func toBase64() -> String {
//        return Data(self.utf8).base64EncodedString()
//    }
//    

    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }
    
    func isBegin(with string:NSString) -> Bool {
        return self.hasPrefix(string as String) ? true : false
    }
    
    func isEnd(With string : NSString) -> Bool {
        return self.hasSuffix(string as String) ? true : false
    }
    
    /**
     Check email
     */
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    public var length: Int {
        return self.count
    }
    
    /**
     phone number
     */
    func isValidPhoneNumber() -> Bool {
        let regex : NSString = "[235689][0-9]{6}([0-9]{3})?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
    
    /**
     url
     */
    func isValidUrl() -> Bool {
        let regex : NSString = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
    
//    func substring(_ startIndex: Int, length: Int) -> String {
//        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
//        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
//        return String(self[start..<end])
//    }
}

/*
 Will generate radom string based on length
 */
public func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

public func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
