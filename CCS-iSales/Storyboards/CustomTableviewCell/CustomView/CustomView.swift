//
//  CustomView.swift
//  CCS-iSales
//
//  Created by C100-104 on 04/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import Alamofire
import PKHUD

protocol CustomViewDelegate {
    func hideCustomView()
    func updateTableview()
}

class CustomView: BaseViewController {
    
    var customViewDelegate: CustomViewDelegate!
    
    @IBOutlet var viewOptions: UIView!
    var isVisited  = false
    
    @IBOutlet var btnMarkAsCompleted: UIButton!
    @IBOutlet var viewWriteNote: UIView!
    @IBOutlet var textViewNote: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setProgress()
//        let touchGesture = UIGestureRecognizer(target: self, action: #selector(self.respondToTouchGesture(_:)))
//        self.view.isUserInteractionEnabled = true
//        self.view.addGestureRecognizer(touchGesture)
        self.textViewNote.placeholder = "Write Something..."
        self.textViewNote.placeholderColor = UIColor(red: 135/255, green: 154/255, blue: 173/255, alpha: 1.0)
		
    }
    
    @objc func respondToTouchGesture(_ sender : Any)
    {
        self.hideCustomView()
    }
    
    //MARK:- Show Hide Methods
    
    func showCustomViewInCurrentView(viewDisplay: UIView, isVisited: Bool)
    {
        self.isVisited = isVisited
        self.view.frame = CGRect(x: 0, y: viewDisplay.frame.height, width: viewDisplay.frame.width, height: screenHeight)
        NSLog("%@", NSCoder.string(for: self.view.frame))
        viewDisplay.addSubview(self.view!)
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.view.frame = CGRect(x: 0, y: viewDisplay.frame.height - self.view.frame.size.height, width: viewDisplay.frame.width, height: self.view.frame.size.height)
        }, completion: {(finished: Bool) -> Void in
            if isVisited
            {
                self.btnMarkAsCompleted.isEnabled = false
                self.btnMarkAsCompleted.setTitleColor(UIColor.gray, for: .normal)
            }
            else
            {
                self.btnMarkAsCompleted.isEnabled = true
                self.btnMarkAsCompleted.setTitleColor(UIColor.black, for: .normal)
            }
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            
        })
    }
    
    func hideCustomView()
    {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor = UIColor.clear
        }, completion: {_ in
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - self.view.frame.size.height, width: UIScreen.main.bounds.size.width, height: self.view.frame.size.height)
            UIView.animate(withDuration: 0.15, animations: {() -> Void in
                self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: self.view.frame.size.height)
            }, completion: {(finished: Bool) -> Void in
                self.view!.removeFromSuperview()
                self.customViewDelegate.hideCustomView()
            })
        })
    }
    
    //MARK: Button Click Methods
    @IBAction func actionCancleDialog(_ sender: Any) {
        currCustomerPos = 0
		self.textViewNote.resignFirstResponder()
        hideCustomView()
    }
    
    @IBAction func actionSubmitNote(_ sender: Any) {
		if self.textViewNote.text.isEmpty
        {
            showAlert(title: "Warning", message: "Please write something.")
        }
        else
        {
			self.textViewNote.resignFirstResponder()
            updateData(1)
        }
		
    }
    @IBAction func actionMarkCompleted(_ sender: Any) {
        updateData(0)
    }
    
    @IBAction func actionShowWriteNoteView(_ sender: Any) {
        self.textViewNote.becomeFirstResponder()
        UIView.transition(with: self.viewOptions, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.viewOptions.isHidden = true
        }, completion: { _ in
            UIView.transition(with: self.viewWriteNote, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.viewWriteNote.isHidden = false
            }, completion:  nil)
        })
    }
    
    //MARK:- Get data on tap
    func updateData(_ index : Int)
    {
        if isNetworkConnected
        {
            var UserData: Parameters!
            var url : String!
            HUD.show(.progress)
            
            // 0 - Mark as Visited
            // 1 - Add Note
            if index == 0
            {
                UserData = ["user_id" : "\(UserId)",
                    "customer_id" : "\(selectedCustomerId)"]
                url = MarkAsVisitedURL
            }
            else
            {
                UserData = ["user_id" : "\(UserId)",
                    "customer_id" : "\(selectedCustomerId)",
                    "note" : textViewNote.text]
                
                url = AddNoteURL
            }
            
            APIHelper.shared.postJsonRequest(url: url, parameter: UserData, headers: headers, completion: { iscompleted,status,response in
                
                //self.view.dismissProgress()
                HUD.hide(animated: true)
                
                if iscompleted
                {
                    
                    if(response["status"] as! String != "success")
                    {
                        self.showAlert(title: "Alert", message: response["message"] as! String)
                    }
                    else
                    {
						if index == 0
						{
                        	self.updateStatus()
						}
                    }
                    self.customViewDelegate.updateTableview()
                }
                else
                {
                    self.showAlert(title: "Warning", message: "Something went wrong.\n Please try after some time. ")
                }
            })
        }
        else
        {
            showAlert(title: "Alert", message: "Please check your internet connection.")
        }
    }
    
    //MARK:- Call Socket Updatew Status
    
    func updateStatus() {
        
        let dic = NSMutableDictionary()
        dic.setValue(UserId, forKey: "seller_id")
		dic.setValue(selectedCustomerId, forKey: "customer_id")
        
        APP_DELEGATE.socketIOHandler?.sendStatus(data: dic)
        
    }
}
