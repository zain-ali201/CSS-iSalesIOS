//
//  ProfileVC.swift
//  CCS-iSales
//
//  Created by C100-104 on 03/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit
//import ACFloatingTextfield_Swift


class ProfileVC: BaseViewController {

    
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var txtPhoneNumber: ACFloatingTextfield!
    @IBOutlet var txtEmail: ACFloatingTextfield!
    @IBOutlet var txtName: ACFloatingTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          btnLogout.layer.cornerRadius = btnLogout.bounds.height / 2
        setProfileData()

    }
    override func viewWillAppear(_ animated: Bool) {
         self.updateNavigationButton(backBtnImageName: "back", title: "Profile", tintColor: UIColor.black, clearNav: false)
    }
    @objc override func back(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
        {
            UIView.transition(with:nav.view, duration:0.4, options:.transitionCrossDissolve, animations: {
                _ = nav.popViewController(animated:false)
            }, completion:nil)
        }
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        
        doLogout()
      
    }
    
    func doLogout()
    {
           let alert = UIAlertController(title: "Confirm Logout"  , message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            UserDetails = nil
            UserId = 0
            UserDefaults.standard.removeCustomObject(forKey: "UserDetails")
            UserDefaults.standard.setValue(nil,forKey: "id")
            
              UIView.animate(withDuration: 0.75, animations: { () -> Void in
                UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
                UIView.setAnimationTransition(UIView.AnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            })
            
            super.viewWillDisappear(true)
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let ViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
			APP_DELEGATE.window?.rootViewController = ViewController
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default , handler: { _ in
            alert.dismiss(animated: true, completion:nil)
        }))
          self.present(alert, animated: true, completion: nil)
    }

    func setProfileData()  {
        self.txtName.isEnabled = false
        self.txtName.text = UserDetails.firstname! + " " + UserDetails.lastname!
        self.txtPhoneNumber.isEnabled = false
        self.txtPhoneNumber.text = UserDetails.contactNo!
        self.txtEmail.isEnabled = false
        self.txtEmail.text = UserDetails.email!
    }
}
