//
//  NoDataTVCell.swift
//  CCS-iSales
//
//  Created by C100-104 on 07/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import UIKit

class NoDataTVCell: UITableViewCell {

    @IBOutlet var uiview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        uiview.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
