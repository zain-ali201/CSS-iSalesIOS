//
//  CustomerDetailTVCell.swift
//  CCS-iSales
//
//  Created by C100-104 on 03/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit

class CustomerDetailTVCell: UITableViewCell {

    @IBOutlet var imgViewStatusColor: UIImageView!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblEmailAddress: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnOption: UIButton!

    @IBOutlet var uiview: UIView!
    @IBOutlet var viewNoteLine: UIView!
    @IBOutlet var lblNote: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       viewNoteLine.isHidden = true
        lblNote.isHidden = true
        uiview.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
