//
//  WebService-Prefix.swift
//  Assignment-10 BAZAAR App
//
//  Created by C100-104 on 19/02/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import Foundation
//MARK: - Service Type
let GET = "GET"
let POST = "POST"
let MEDIA = "MEDIA"

let MESSAGE = "Please try again later."
let RESPONSESUCCESS = "success"
//http://52.43.156.155/iSales/WS/MobileAPI/Webservices.php/?Service=
let ServerURL = "http://52.43.156.155/iSales/WS/"
let BaseURL = "\(ServerURL)MobileAPI/Webservices.php/?Service="
//


//socket I/O
let SOCKET_SERVER_PATH = "http://52.43.156.155:3000"
let SoketChangeStatus = "status_update"


//WEBSERVICES

let loginURL = "\(BaseURL)Login"
let getCustomerURL = "\(BaseURL)GetMyCustomers"
let MarkAsVisitedURL = "\(BaseURL)MarkAsVisited"
let AddNoteURL = "\(BaseURL)AddNote"


//Keys
let access_key = "nousername"
let secret_key = ""

//Headers
let headers = [
    "content-type": "application/json",
    "cache-control": "no-cache",
    ]
