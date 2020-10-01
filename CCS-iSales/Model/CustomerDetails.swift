//
//  Data.swift
//
//  Created by C100-104 on 07/05/19
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public class CustomerDetails: NSCoding {

	// MARK: Declaration for string constants to be used to decode and also serialize.
	private let kDataNoteKey: String = "note"
	private let kDataDriversAreaKey: String = "drivers_area"
	private let kDataStatusKey: String = "status"
	private let kDataInternalIdentifierKey: String = "id"
	private let kDataTotalDaysKey: String = "total_days"
	private let kDataIsActiveKey: String = "is_active"
	private let kDataCompanyNameKey: String = "company_name"
	private let kDataCreatedDateKey: String = "created_date"
	private let kDataAddressKey: String = "address"
	private let kDataVisitedDateKey: String = "visited_date"
	private let kDataVisitedDaysKey: String = "visited_days"
	private let kDataMixingSchemeKey: String = "mixing_scheme"
	
	// MARK: Properties
	public var note: String?
	public var driversArea: String?
	public var status: String?
	public var internalIdentifier: Int?
	public var totalDays: Int?
	public var isActive: Int?
	public var companyName: String?
	public var createdDate: String?
	public var address: String?
	public var visitedDate: String?
	public var visitedDays: Int?
	public var mixingScheme: Int?
	
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
		note = json[kDataNoteKey].string
		driversArea = json[kDataDriversAreaKey].string
		status = json[kDataStatusKey].string
		internalIdentifier = json[kDataInternalIdentifierKey].int
		totalDays = json[kDataTotalDaysKey].int
		isActive = json[kDataIsActiveKey].int
		companyName = json[kDataCompanyNameKey].string
		createdDate = json[kDataCreatedDateKey].string
		address = json[kDataAddressKey].string
		visitedDate = json[kDataVisitedDateKey].string
		visitedDays = json[kDataVisitedDaysKey].int
		mixingScheme = json[kDataMixingSchemeKey].int
	}
	
	/**
	Generates description of the object in the form of a NSDictionary.
	- returns: A Key value pair containing all valid values in the object.
	*/
	public func dictionaryRepresentation() -> [String: Any] {
		var dictionary: [String: Any] = [:]
		if let value = note { dictionary[kDataNoteKey] = value }
		if let value = driversArea { dictionary[kDataDriversAreaKey] = value }
		if let value = status { dictionary[kDataStatusKey] = value }
		if let value = internalIdentifier { dictionary[kDataInternalIdentifierKey] = value }
		if let value = totalDays { dictionary[kDataTotalDaysKey] = value }
		if let value = isActive { dictionary[kDataIsActiveKey] = value }
		if let value = companyName { dictionary[kDataCompanyNameKey] = value }
		if let value = createdDate { dictionary[kDataCreatedDateKey] = value }
		if let value = address { dictionary[kDataAddressKey] = value }
		if let value = visitedDate { dictionary[kDataVisitedDateKey] = value }
		if let value = visitedDays { dictionary[kDataVisitedDaysKey] = value }
		if let value = mixingScheme { dictionary[kDataMixingSchemeKey] = value }
		return dictionary
	}
	
	// MARK: NSCoding Protocol
	required public init(coder aDecoder: NSCoder) {
		self.note = aDecoder.decodeObject(forKey: kDataNoteKey) as? String
		self.driversArea = aDecoder.decodeObject(forKey: kDataDriversAreaKey) as? String
		self.status = aDecoder.decodeObject(forKey: kDataStatusKey) as? String
		self.internalIdentifier = aDecoder.decodeObject(forKey: kDataInternalIdentifierKey) as? Int
		self.totalDays = aDecoder.decodeObject(forKey: kDataTotalDaysKey) as? Int
		self.isActive = aDecoder.decodeObject(forKey: kDataIsActiveKey) as? Int
		self.companyName = aDecoder.decodeObject(forKey: kDataCompanyNameKey) as? String
		self.createdDate = aDecoder.decodeObject(forKey: kDataCreatedDateKey) as? String
		self.address = aDecoder.decodeObject(forKey: kDataAddressKey) as? String
		self.visitedDate = aDecoder.decodeObject(forKey: kDataVisitedDateKey) as? String
		self.visitedDays = aDecoder.decodeObject(forKey: kDataVisitedDaysKey) as? Int
		self.mixingScheme = aDecoder.decodeObject(forKey: kDataMixingSchemeKey) as? Int
	}
	
	public func encode(with aCoder: NSCoder) {
		aCoder.encode(note, forKey: kDataNoteKey)
		aCoder.encode(driversArea, forKey: kDataDriversAreaKey)
		aCoder.encode(status, forKey: kDataStatusKey)
		aCoder.encode(internalIdentifier, forKey: kDataInternalIdentifierKey)
		aCoder.encode(totalDays, forKey: kDataTotalDaysKey)
		aCoder.encode(isActive, forKey: kDataIsActiveKey)
		aCoder.encode(companyName, forKey: kDataCompanyNameKey)
		aCoder.encode(createdDate, forKey: kDataCreatedDateKey)
		aCoder.encode(address, forKey: kDataAddressKey)
		aCoder.encode(visitedDate, forKey: kDataVisitedDateKey)
		aCoder.encode(visitedDays, forKey: kDataVisitedDaysKey)
		aCoder.encode(mixingScheme, forKey: kDataMixingSchemeKey)
	}
	
}
