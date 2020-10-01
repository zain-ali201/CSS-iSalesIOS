//
//  UITableViewExtension + Helper.swift
//  CCS-iSales
//
//  Created by C100-104 on 09/05/19.
//  Copyright © 2019 C100-104. All rights reserved.
//

import Foundation
import UIKit    
extension UITableView {
    
    public enum EffectEnum {
        case roll
        case LeftAndRight
    }
    
    public func reloadData(effect: EffectEnum) {
        self.reloadData()
        
        switch effect {
        case .roll:
            roll()
            break
        case .LeftAndRight:
            leftAndRightMove()
            break
        }
        
    }
    
    private func roll() {
        let cells = self.visibleCells
        
        let tableViewHeight = self.bounds.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func leftAndRightMove() {
        let cells = self.visibleCells
        
        let tableViewWidth = self.bounds.width
        
        var alternateFlag = false
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: alternateFlag ? tableViewWidth : tableViewWidth * -1, y: 0)
            alternateFlag = !alternateFlag
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 2, delay: Double(delayCounter) * 0.035, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
