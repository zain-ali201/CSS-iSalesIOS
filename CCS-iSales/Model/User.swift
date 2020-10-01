//
//  User.swift
//
//  Created by C100-104 on 07/05/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON


public class User: NSObject, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private let kUserFirstnameKey: String = "firstname"
  private let kUserInternalIdentifierKey: String = "id"
  private let kUserLastnameKey: String = "lastname"
  private let kUserEmailKey: String = "email"
  private let kUserAddressKey: String = "address"
  private let kUserCreatedDateKey: String = "created_date"
  private let kUserTokenKey: String = "token"
  private let kUserIsActiveKey: String = "is_active"
  private let kUserRoleKey: String = "role"
  private let kUserContactNoKey: String = "contact_no"

  // MARK: Properties
  public var firstname: String?
  public var internalIdentifier: Int?
  public var lastname: String?
  public var email: String?
  public var address: String?
  public var createdDate: String?
  public var token: String?
  public var isActive: Int?
  public var role: String?
  public var contactNo: String?

  // MARK: SwiftyJSON Initalizers
  /**
   Initates the instance based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
  */
  convenience public init(object: Any) {
    self.init(json: JSON(object))
  }

  /**
   Initates the instance based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
  */
  public init(json: JSON) {
    firstname = json[kUserFirstnameKey].string
    internalIdentifier = json[kUserInternalIdentifierKey].int
    lastname = json[kUserLastnameKey].string
    email = json[kUserEmailKey].string
    address = json[kUserAddressKey].string
    createdDate = json[kUserCreatedDateKey].string
    token = json[kUserTokenKey].string
    isActive = json[kUserIsActiveKey].int
    role = json[kUserRoleKey].string
    contactNo = json[kUserContactNoKey].string
  }

  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
  */
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = firstname { dictionary[kUserFirstnameKey] = value }
    if let value = internalIdentifier { dictionary[kUserInternalIdentifierKey] = value }
    if let value = lastname { dictionary[kUserLastnameKey] = value }
    if let value = email { dictionary[kUserEmailKey] = value }
    if let value = address { dictionary[kUserAddressKey] = value }
    if let value = createdDate { dictionary[kUserCreatedDateKey] = value }
    if let value = token { dictionary[kUserTokenKey] = value }
    if let value = isActive { dictionary[kUserIsActiveKey] = value }
    if let value = role { dictionary[kUserRoleKey] = value }
    if let value = contactNo { dictionary[kUserContactNoKey] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.firstname = aDecoder.decodeObject(forKey: kUserFirstnameKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kUserInternalIdentifierKey) as? Int
    self.lastname = aDecoder.decodeObject(forKey: kUserLastnameKey) as? String
    self.email = aDecoder.decodeObject(forKey: kUserEmailKey) as? String
    self.address = aDecoder.decodeObject(forKey: kUserAddressKey) as? String
    self.createdDate = aDecoder.decodeObject(forKey: kUserCreatedDateKey) as? String
    self.token = aDecoder.decodeObject(forKey: kUserTokenKey) as? String
    self.isActive = aDecoder.decodeObject(forKey: kUserIsActiveKey) as? Int
    self.role = aDecoder.decodeObject(forKey: kUserRoleKey) as? String
    self.contactNo = aDecoder.decodeObject(forKey: kUserContactNoKey) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(firstname, forKey: kUserFirstnameKey)
    aCoder.encode(internalIdentifier, forKey: kUserInternalIdentifierKey)
    aCoder.encode(lastname, forKey: kUserLastnameKey)
    aCoder.encode(email, forKey: kUserEmailKey)
    aCoder.encode(address, forKey: kUserAddressKey)
    aCoder.encode(createdDate, forKey: kUserCreatedDateKey)
    aCoder.encode(token, forKey: kUserTokenKey)
    aCoder.encode(isActive, forKey: kUserIsActiveKey)
    aCoder.encode(role, forKey: kUserRoleKey)
    aCoder.encode(contactNo, forKey: kUserContactNoKey)
  }

}
