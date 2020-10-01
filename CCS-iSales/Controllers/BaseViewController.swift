//
//  BaseViewController.swift
//  CCS-iSales
//
//  Created by C100-104 on 03/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import  Reachability
//import ACFloatingTextfield_Swift
import SocketIO

class BaseViewController: UIViewController {

    let reachability = Reachability()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProgress()
        checkRechabiliy()
        
    }
    //MARK:- Check Network Reachability
    func checkRechabiliy()
    {

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                isNetworkConnected =  true
            } else {
                print("Reachable via Cellular")
                isNetworkConnected =  true
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showAlert(title: "Alert", message: "Please check your internet connection.")
            isNetworkConnected = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
