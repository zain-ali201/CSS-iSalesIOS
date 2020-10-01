//
//  Constants.swift
//  26Dates
//
//  Created by C100-104 on 06/03/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import Foundation
import UIKit

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size

let selectedMenuColor = UIColor.init(red: 244/255, green: 77/255, blue: 65/255, alpha: 1.0)

var UserDetails: User!
var UserId : Int  = 0
var isNetworkConnected = true
var selectedCustomerId :  Int = 0
var socketStatusUpdated : Bool?
var currCustomerPos : Int = 0
