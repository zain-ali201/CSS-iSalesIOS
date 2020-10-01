//
//  HomeVC.swift
//  CCS-iSales
//
//  Created by C100-104 on 03/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import SwiftyJSON
import DropDown

class HomeVC: BaseViewController, UITextFieldDelegate
{
	//MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var viewSegment: UIView!
	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var topShadowView: UIView!
    @IBOutlet var filterView: UIView!
    @IBOutlet var filterSubView: UIView!
    
    @IBOutlet var mixingView: UIButton!
    @IBOutlet var driverView: UIButton!
    @IBOutlet var txtName: UITextField!
    
//    @IBOutlet var radioBtn1: UIButton!
//    @IBOutlet var radioBtn2: UIButton!
//    @IBOutlet var radioBtn3: UIButton!
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var lblMixing: UILabel!
    @IBOutlet var lblDriver: UILabel!
    
	//MARK:- Var Declarations
    private let refreshControl = UIRefreshControl()
    var customView: CustomView!
    var arrCustomerDetails : [CustomerDetails] = []
	var arrFilteredCustomerDetails : [CustomerDetails] = []
    var isRefresh : Bool = false
	var firstLoad : Bool = true
    
    let mixing = DropDown()
    let driver = DropDown()
    
    var mixingStr = ""
    var driverStr = ""
    var customerStr = ""
    
    var mixingFlag = false
    var driverFlag = false
    var customerFlag = false
    
    var searchArray = [String]()
    
	//MARK:- Main Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
		firstLoad = true
		
        saveBtn.layer.cornerRadius = 5.0
        filterSubView.cornerRadius(radius: 5.0)
        mixingView.cornerRadius(radius: 5.0)
        driverView.cornerRadius(radius: 5.0)
        
        mixingView.viewBorder(width: 1, color: UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1))
        driverView.viewBorder(width: 1, color: UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1))
        
        mixing.anchorView = mixingView
        mixing.dataSource = ["Spectral", "Aquamax", "Baslac"]
//        mixing.selectRow(0)
        mixing.bottomOffset = CGPoint(x: 0, y: mixingView.bounds.height)
        
        driver.anchorView = driverView
        driver.dataSource = ["North Essex", "South Essex", "North London", "East London", "Local"]
//        driver.selectRow(0)
        driver.bottomOffset = CGPoint(x: 0, y: mixingView.bounds.height)
        
        mixing.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.mixingView.setTitle(String(format: "  %@", item), for: .normal)
            self.mixingStr = "\(index + 1)"
        }
        
        driver.selectionAction = { [unowned self] (index: Int, item: String) in
          
            self.driverView.setTitle(String(format: "  %@", item), for: .normal)
            self.driverStr = item
        }
		
        segmentedControl.addUnderlineForSelectedSegment()
        self.tableView.register(UINib(nibName: "CustomerDetailTVCell", bundle: nil), forCellReuseIdentifier:
            "CustomerDetailTVCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
		self.searchBar.delegate = self
		self.searchBar.returnKeyType = .done
		self.searchBar?.searchBarStyle = .minimal
		
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        tableView.isUserInteractionEnabled = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        tableView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        tableView.addGestureRecognizer(swipeLeft)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        getData("all",false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		self.updateNavigationButton(backBtnImageName: "", title: "", tintColor: UIColor(red: 160/255, green: 185/255, blue: 212/255, alpha: 1.0), clearNav: false)
        add_shadow_to_View()
        SetProfileButton()
    }
	
	//MARK:- action Methods
    @objc private func refreshData(_ sender: Any) {
        isRefresh = true
        DispatchQueue.main.async {
            
            if self.segmentedControl.selectedSegmentIndex == 0
            {
                self.getData("all",true)
            }
            else if self.segmentedControl.selectedSegmentIndex == 1
            {
                self.getData("bill",true)
            }
            else if self.segmentedControl.selectedSegmentIndex == 2
            {
                self.getData("colin",true)
            }
            else if self.segmentedControl.selectedSegmentIndex == 3
            {
                self.getData("billy",true)
            }
        }
    }
    
    @objc func ShowProfile(_ sender:Any)
    {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        if let nav = self.navigationController
        {
            UIView.transition(with:nav.view, duration:0.4, options:.transitionCrossDissolve, animations: {
                _ = nav.pushViewController(nextViewController, animated: false)
            }, completion:nil)
        }
        //self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                if segmentedControl.selectedSegmentIndex > 0 {
                    segmentedControl.selectedSegmentIndex -= 1
                    segmentedControl.sendActions(for: .valueChanged)
                }
            case .left:
                if segmentedControl.selectedSegmentIndex < segmentedControl.numberOfSegments - 1 {
                    segmentedControl.selectedSegmentIndex += 1
                    segmentedControl.sendActions(for: .valueChanged)
                }
            default:
                break
            }
        }
    }
    
    //MARK:- Functions
    func add_shadow_to_View()
    {
		self.topShadowView.layer.masksToBounds = false
		self.topShadowView.layer.shadowColor = UIColor.black.cgColor
		self.topShadowView.layer.shadowOffset =  CGSize(width: 0, height: 10.0)
		self.topShadowView.layer.shadowOpacity = 0.1
		self.topShadowView.layer.shadowRadius = 10
		
		
        self.viewSegment.layer.masksToBounds = false
        self.viewSegment.layer.shadowColor = UIColor.black.cgColor
        self.viewSegment.layer.shadowOffset =  CGSize(width: 0, height: -10.0)
        self.viewSegment.layer.shadowOpacity = 0.1
        self.viewSegment.layer.shadowRadius = 10
    }
    
    func SetProfileButton()
    {
        let ProfileBarButton = UIBarButtonItem(title: "",
                                               style: UIBarButtonItem.Style.plain,
                                               target: self,
                                               action: #selector(self.ShowProfile(_:)))
        
        ProfileBarButton.image = UIImage(named: "profile")
        self.navigationItem.rightBarButtonItem = ProfileBarButton
    }

    
    // MARK:- SegmentedControl Click Handle
    
    func changeRadioButtons()
    {
//        radioBtn1.setImage(UIImage(named: "radioinactive"), for: .normal)
//        radioBtn2.setImage(UIImage(named: "radioinactive"), for: .normal)
//        radioBtn3.setImage(UIImage(named: "radioinactive"), for: .normal)
        
        mixingFlag = false
        driverFlag = false
        customerFlag = false
    }
    
    @IBAction func clickBtnAction(button: UIButton) {
        
        if button.tag == 1001
        {
            mixing.show()
            driver.hide()
        }
        else
        {
            driver.show()
            mixing.hide()
        }
    }
    
    @IBAction func filterBtnAction(_ sender: Any)
    {
        mixingStr = ""
        self.mixingView.setTitle("  Mixing Scheme", for: .normal)
        driverStr = ""
        self.driverView.setTitle("  Drivers Area", for: .normal)
        customerStr = ""
        txtName.text = ""
        driver.selectRow(0)
        mixing.selectRow(0)
        
        filterView.alpha = 1
    }
    
    @IBAction func crossBtnAction(_ sender: Any)
    {
        filterView.alpha = 0
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
        filterData()
        filterView.alpha = 0
    }
    
    func filterData()
    {
        arrFilteredCustomerDetails.removeAll()

        if mixingStr != ""
        {
            for index in 0...arrCustomerDetails.count - 1
            {
                let fullname = "\(arrCustomerDetails[index].mixingScheme ?? 0)"
                if fullname.localizedCaseInsensitiveContains(mixingStr)
                {
                    arrFilteredCustomerDetails.append(arrCustomerDetails[index])
                }
            }
        }
        
        if driverStr != ""
        {
            var customerArray : [CustomerDetails] = []
            
            if arrFilteredCustomerDetails.count > 0
            {
                customerArray = arrFilteredCustomerDetails
                arrFilteredCustomerDetails.removeAll()
            }
            else
            {
                customerArray = arrCustomerDetails
            }
            
            for index in 0...customerArray.count - 1
            {
                let fullname = customerArray[index].driversArea ?? ""
                if fullname.localizedCaseInsensitiveContains(driverStr)
                {
                    arrFilteredCustomerDetails.append(customerArray[index])
                }
            }
        }
        
        if !txtName.text!.isEmpty
        {
            var customerArray : [CustomerDetails] = []
            
            if arrFilteredCustomerDetails.count > 0
            {
                customerArray = arrFilteredCustomerDetails
                arrFilteredCustomerDetails.removeAll()
            }
            else
            {
                customerArray = arrCustomerDetails
            }
            
            for index in 0...customerArray.count - 1
            {
                let fullname = customerArray[index].companyName ?? ""
                if fullname.localizedCaseInsensitiveContains(txtName.text!)
                {
                    arrFilteredCustomerDetails.append(customerArray[index])
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func actionSwitchScreen(_ sender: UISegmentedControl)
    {
        sender.changeUnderlinePosition()
        if sender.selectedSegmentIndex == 0
        {
            getData("all",false)
        }
        else if sender.selectedSegmentIndex == 1
        {
            getData("bill",false)
        }
        else if sender.selectedSegmentIndex == 2
        {
            getData("colin",false)
        }
        else if sender.selectedSegmentIndex == 3
        {
            getData("billy",false)
        }
    }
    
    func convertDate(_ date : String) -> String
    {
		if date == ""
		{
			return ""
		}
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    @objc func showView(_ sender: UIButton)
    {
        selectedCustomerId = arrFilteredCustomerDetails[sender.tag].internalIdentifier!
        currCustomerPos = sender.tag
		var days = 0
		if arrFilteredCustomerDetails[sender.tag].visitedDays != nil
		{
			days = arrFilteredCustomerDetails[sender.tag].visitedDays ?? 0
		}
		else
		{
			days = arrFilteredCustomerDetails[sender.tag].totalDays ?? 0
		}
        var isVisited = false
        if days < 15
        {
            isVisited = true
        }
        else if days >= 15 && days < 30
        {
            isVisited = false
        }
        else if days >= 30
        {
           isVisited = false
        }
        else
        {
            isVisited = true
        }
        
        if customView == nil
        {
            customView = CustomView(nibName: "CustomView", bundle: nil)
            customView!.customViewDelegate = self
            customView!.showCustomViewInCurrentView(viewDisplay: self.view, isVisited: isVisited)
            
        }
//        else
//        {
//            customView!.hideCustomView()
//            customView = nil
//            selectedCustomerId = 0
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    //MARK:- Attributed text set method
    func setHeaderText(text: String) -> NSMutableAttributedString
    {
        let myString = text
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
        let myAttrString = NSMutableAttributedString(string: myString, attributes: myAttribute)
        return myAttrString
    }
    
    func setBodyText(text: String) -> NSMutableAttributedString
    {
        let myString = text
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor(red: 159/255, green: 185/255, blue: 212/255, alpha: 1.0) ]
        let myAttrString = NSMutableAttributedString(string: myString, attributes: myAttribute)
        return myAttrString
    }
    
    //MARK:- Get data on tap
    func getData(_ type : String,_ is_refresh : Bool)
    {
        if isNetworkConnected
        {
            if !(is_refresh)
            {
                HUD.show(.progress)
            }
            print(UserId)
            let UserData: Parameters = ["user_id" : "\(UserId)",
                "type":type]
            APIHelper.shared.postJsonRequest(url: getCustomerURL, parameter: UserData, headers: headers, completion: { iscompleted,status,response in
                
                HUD.hide(animated: true)
                
                if is_refresh
                {
                    self.refreshControl.endRefreshing()
                    self.isRefresh = false
                }
                
                if iscompleted
                {
					self.firstLoad = false
                    if(response["status"] != nil && response["status"] as! String != "success")
                    {
                        self.arrCustomerDetails.removeAll()
						self.arrFilteredCustomerDetails.removeAll()
//                        if response["message"] as! String != "Data not available."
//                        {
//                            self.showAlert(title: "Alert", message: "There are no records currently")
//                        }
                    }
                    else
                    {
                        if response["data"] != nil
                        {
                            let data = response["data"] as! NSArray
                            self.arrCustomerDetails.removeAll()
							self.arrFilteredCustomerDetails.removeAll()
                            print(data)
                            var count = 0
                            for customer in data
                            {
                                self.arrCustomerDetails.append(CustomerDetails(json: JSON(customer)))
                                count += 1
                            }
                        }
                        else
                        {
                            self.arrCustomerDetails.removeAll()
                            self.arrFilteredCustomerDetails.removeAll()
//                            self.showAlert(title: "Alert", message: "There are no records currently")
                        }
                    }
                    
                    if self.arrCustomerDetails.count == 0
                    {
						self.arrFilteredCustomerDetails = self.arrCustomerDetails
						self.searchBar.text = ""
						self.searchBar.resignFirstResponder()
						self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                    else
                    {
                        if !(is_refresh)
                        {
							self.arrFilteredCustomerDetails = self.arrCustomerDetails
							self.searchBar.text = ""
							self.searchBar.resignFirstResponder()
							self.tableView.reloadData(effect: .roll)
                            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        }
                        else
                        {
							
                            self.arrFilteredCustomerDetails = self.arrCustomerDetails
                            if currCustomerPos != 0
                            {
								
								self.searchBar.text = ""
								self.searchBar.resignFirstResponder()
                                self.tableView.reloadData()
                                currCustomerPos = 0
                            }
                            else
                            {
								self.searchBar.text = ""
								self.searchBar.resignFirstResponder()
                                self.tableView.reloadData()
                                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                            }
                        }
                    }
                }
                else
                {
					self.searchBar.text = ""
					self.searchBar.resignFirstResponder()
                    self.arrCustomerDetails.removeAll()
					self.arrFilteredCustomerDetails.removeAll()
                    self.tableView.reloadData()
                    
                    self.showAlert(title: "Warning", message: "Something went wrong.\n Please try after some time. ")
                }
            })
        }
        else
        {
            showAlert(title: "Alert", message: "Please check your internet connection.")
			self.arrFilteredCustomerDetails.removeAll()
			self.arrCustomerDetails.removeAll()
			self.searchBar.text = ""
			self.searchBar.resignFirstResponder()
            self.tableView.reloadData()
			self.firstLoad = false
            //self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

//MARK:- TableView Delegate Methods
extension HomeVC : UITableViewDelegate ,UITableViewDataSource
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if  arrFilteredCustomerDetails.count == 0
		{
			return 60
		}
		return tableView.estimatedRowHeight
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if  arrFilteredCustomerDetails.count == 0 && !firstLoad
		{
			return 1
		}
		return arrFilteredCustomerDetails.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if  arrFilteredCustomerDetails.count == 0 && !(self.isRefresh) && !firstLoad
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTVCell", for: indexPath) as! NoDataTVCell
			return cell
		}
		if  arrFilteredCustomerDetails.count != 0
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerDetailTVCell", for: indexPath) as! CustomerDetailTVCell
			cell.btnOption.addTarget(self, action: #selector(showView(_:)), for: .touchUpInside)
			cell.btnOption.tag = indexPath.row
			
            let mixingScheme = arrFilteredCustomerDetails[indexPath.row].mixingScheme
            print(mixingScheme)
            
            let driverArea = arrFilteredCustomerDetails[indexPath.row].driversArea
            print(driverArea)
            
			let companyName = arrFilteredCustomerDetails[indexPath.row].companyName
			cell.lblCustomerName.text = companyName
			//cell.lblPhoneNumber.text = arrFilteredCustomerDetails[indexPath.row].contactNo ?? "---"
			//cell.lblEmailAddress.text = arrFilteredCustomerDetails[indexPath.row].email ?? "---"
			//cell.lblAddress.text =  arrFilteredCustomerDetails[indexPath.row].address ?? "---"
			var days = 0
			if arrFilteredCustomerDetails[indexPath.row].visitedDays != nil
			{
				days = arrFilteredCustomerDetails[indexPath.row].visitedDays ?? 0
			}
			else
			{
				days = arrFilteredCustomerDetails[indexPath.row].totalDays ?? 0
			}
			if days < 15
			{
				cell.imgViewStatusColor.image = UIImage(named: "green_dot")
				let date = Date()
				let format = DateFormatter()
				format.dateFormat = "yyyy-MM-dd HH:mm:ss"
				let formattedDate = format.string(from: date)
				cell.lblDate.text = convertDate(formattedDate)
			}
			else if days >= 15 && days < 30
			{
				cell.imgViewStatusColor.image = UIImage(named: "orange_dot")
				cell.lblDate.text = convertDate(arrCustomerDetails[indexPath.row].visitedDate ?? "")
			}
			else if days > 30
			{
				cell.imgViewStatusColor.image = UIImage(named: "red_dot")
				cell.lblDate.text = convertDate(arrFilteredCustomerDetails[indexPath.row].visitedDate ?? "")
			}
			else
			{
				cell.imgViewStatusColor.image = UIImage(named: "green_dot")
				cell.lblDate.text = convertDate(arrFilteredCustomerDetails[indexPath.row].visitedDate ?? "")
			}
			
			if arrFilteredCustomerDetails[indexPath.row].note ?? nil != nil
			{
				if arrFilteredCustomerDetails[indexPath.row].note! !=  ""
				{
					let combination = NSMutableAttributedString()
					combination.append(setHeaderText(text: "Note : "))
					combination.append(setBodyText(text: arrFilteredCustomerDetails[indexPath.row].note ?? ""))
					cell.lblNote.attributedText = combination
					cell.viewNoteLine.isHidden = false
					cell.lblNote.isHidden = false
				}
				else
				{
					cell.viewNoteLine.isHidden = true
					cell.lblNote.isHidden = true
				}
			}
			else
			{
				cell.viewNoteLine.isHidden = true
				cell.lblNote.isHidden = true
			}
			
			return cell
		}
		return UITableViewCell()
	}
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
		headerView.backgroundColor = .clear
		return headerView
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 8
	}
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
		footerView.backgroundColor = .clear
		
		return footerView
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 8
	}
}

//MARK:- CustomView Delegate Methods
extension HomeVC : CustomViewDelegate
{
	func hideCustomView()
    {
		customView = nil
		selectedCustomerId = 0
	}
	
	func updateTableview() {
		customView!.hideCustomView()
		customView = nil
		selectedCustomerId = 0
		
		if segmentedControl.selectedSegmentIndex == 0
		{
			getData("all",true)
		}
		else if self.segmentedControl.selectedSegmentIndex == 1
        {
            self.getData("bill",true)
        }
        else if self.segmentedControl.selectedSegmentIndex == 2
        {
            self.getData("colin",true)
        }
        else if self.segmentedControl.selectedSegmentIndex == 3
        {
            self.getData("billy",true)
        }
	}
}

//MARK:- SearBar Delegate
extension HomeVC : UISearchBarDelegate
{
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		arrFilteredCustomerDetails.removeAll()
		
		if searchBar.text != "" && arrCustomerDetails.count != 0
		{
			for index in 0...arrCustomerDetails.count - 1
			{
//				let fname = arrCustomerDetails[index].firstname ?? ""
//				let lname = arrCustomerDetails[index].lastname ?? ""
				let fullname = arrCustomerDetails[index].companyName ?? ""
				if fullname.localizedCaseInsensitiveContains(searchText)
				{
					arrFilteredCustomerDetails.append(arrCustomerDetails[index])
				}
			}
		}
		else
		{
			arrFilteredCustomerDetails = arrCustomerDetails
		}
		self.tableView.reloadData()
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		 searchBar.resignFirstResponder()
	}
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		 searchBar.resignFirstResponder()
	}
}

extension UIView
{
    func cornerRadius(radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func viewBorder(width: CGFloat, color: UIColor)
    {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
