//
//  LoginVC.swift
//  CCS-iSales
//
//  Created by C100-104 on 03/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit
//import ACFloatingTextfield_Swift
import Alamofire
import SwiftyJSON
import Crashlytics
import Fabric
import PKHUD

class LoginVC: BaseViewController {
    
    @IBOutlet var btnRememberMe: UIButton!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var stackViewRemeberMe: UIStackView!
    @IBOutlet var imgCheck: UIImageView!
    
    struct login {
        var email: String? = nil
        var password: String? = nil
    }
    var structRequest = login()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = btnLogin.bounds.height / 2
        txtPassword.isSecureTextEntry = true
        //txtEmail.shakeLineWithError = false
        txtEmail.keyboardType = .emailAddress
        //txtPassword.shakeLineWithError = false
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(actionRememberMe(_:)))
        stackViewRemeberMe.addGestureRecognizer(gesture)
		
        btnRememberMe.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
	
    
    
    //MARK:- Check Fields
    func checkEmail() -> Bool
    {
        if (txtEmail.text?.isEmpty)!
        {
			//txtEmail.errorText = "Required"
            //txtEmail.showError()
			self.showAlert(title: "Alert", message: "Please Enter Email Address.")
            return false
        }
        else
        {
            if !(txtEmail.text?.isEmail)!
            {
				//txtEmail.errorText =  "Invalid email address"
                //txtEmail.showError()
				self.showAlert(title: "Alert", message: "Invalid Email Address.")
                return false
            }
            structRequest.email =  txtEmail.text
        }
        return true
    }
    
    func checkPassword() -> Bool
    {
        if (txtPassword.text?.isEmpty)!
        {
			//txtPassword.errorText = "Required"
            //txtPassword.showError()
          //  txtPassword.shakeLineWithError = false
			self.showAlert(title: "Alert", message: "Please Enter Valid Password.")
            return false
        }
        structRequest.password =  txtPassword.text
        return true
    }
    
    func doLogIn()
    {
        HUD.show(.progress)
        let UserData: Parameters = ["email_id":structRequest.email!,
                                    "password":structRequest.password!]
        APIHelper.shared.postJsonRequest(url: loginURL, parameter: UserData, headers: headers, completion: { iscompleted,status,response in

                HUD.hide(animated: true)
                if iscompleted
            {
                if(response["status"] as! String != "success")
                {
                    self.showAlert(title: "Alert", message: response["message"] as! String)
                }
                else
                {
                    // print(response["user"])
                    let userobj = response["user"] as! NSArray
                    let user: User = User(json: JSON(userobj[0]))
                    UserDetails = user
                    UserId = user.internalIdentifier ?? 0
                    if self.btnRememberMe.isSelected
                    {
                        UserDefaults.standard.setCustom(UserDetails, forKey: "UserDetails")
                        UserDefaults.standard.set("\(UserId )", forKey: "id")
                    }
                    Answers.logLogin(withMethod: "Digits",
                                     success: true,
                                     customAttributes: nil)
                    self.txtEmail.text = ""
                    self.txtPassword.text = ""
					let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
					self.navigationController?.pushViewController(nextViewController, animated: true)
//					UIView.animate(withDuration: 0.75, animations: { () -> Void in
//                        UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
//                        self.navigationController?.pushViewController(nextViewController, animated: false)
//						UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController?.view? ?? <#default value#>, cache: false)
//                    })
                    //self.navigationController?.pushViewController(nextViewController, animated: true)
                }
            }
            else
            {
                self.showAlert(title: "Warning", message: "Something went wrong.\n Please try after some time. ")
            }
        })
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        if checkEmail() && checkPassword()
        {
            if isNetworkConnected
            {
                self.doLogIn()
            }
            else
            {
                showAlert(title: "Alert", message: "Please check your internet connection..")
            }
        }
    }
    
    @objc func actionRememberMe(_ sender: Any) {
        self.btnRememberMe.isSelected = !self.btnRememberMe.isSelected
        
    }
}

